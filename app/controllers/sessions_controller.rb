class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to invoices_url
    else
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to ENV['SSO_HOST']
  end
  
  def sso
    sso = SingleSignOn.generate_sso('/')
    
    Rails.logger.warn("Started SSO process\n\n#{sso.diagnostics}")
    
    redirect_to sso.to_url
  end
  
  def sso_login
    params.require(:sso)
    params.require(:sig)

    begin
      sso = SingleSignOn.parse(request.query_string)
    rescue SingleSignOn::ParseError => e
      Rails.logger.warn("Signature parse error\n\n#{e.message}\n\n#{sso&.diagnostics}")
      return render_sso_error(text: I18n.t("sso.login_error"), status: 422)
    end

    if !sso.nonce_valid?
      Rails.logger.warn("Nonce has already expired\n\n#{sso.diagnostics}")
      return render_sso_error(text: I18n.t("sso.timeout_expired"), status: 419)
    end

    return_path = sso.return_path
    sso.expire_nonce!

    begin
      if user = sso.lookup_or_create_user
        unless user.is_member? || user.customer 
          render_sso_error(text: I18n.t("sso.not_authorized"), status: 403)
          return
        end

        Rails.logger.warn("User was logged on #{user.email}\n\n#{sso.diagnostics}")
        
        if user.id != current_user&.id
          log_in user
        end

        # If it's not a relative URL check the host
        if return_path !~ /^\/[^\/]/
          begin
            uri = URI(return_path)
            if (uri.hostname == ENV['HOSTNAME'])
              return_path = uri.to_s
            end
          rescue
            return_path = path("/")
          end
        end

        if return_path.include?("/session/sso")
          return_path = "/"
        end

        redirect_to return_path
      else
        render_sso_error(text: I18n.t("sso.not_found"), status: 500)
      end
    
    rescue ActiveRecord::RecordInvalid => e

      Rails.logger.warn(<<~EOF)
      Verbose SSO log: Record was invalid: #{e.record.class.name} #{e.record.id}
      #{e.record.errors.to_h}

      Attributes:
      #{e.record.attributes.slice(*SingleSignOn::ACCESSORS.map(&:to_s))}

      SSO Diagnostics:
      #{sso.diagnostics}
      EOF

      text = nil

      # If there's a problem with the email we can explain that
      if (e.record.is_a?(User) && e.record.errors[:email].present?)
        if e.record.email.blank?
          text = I18n.t("sso.no_email")
        else
          text = I18n.t("sso.email_error", email: ERB::Util.html_escape(e.record.email))
        end
      end

      render_sso_error(text: text || I18n.t("sso.unknown_error"), status: 500)

    rescue => e
      message = +"Failed to create or lookup user: #{e}."
      message << "  "
      message << "  #{sso.diagnostics}"
      message << "  "
      message << "  #{e.backtrace.join("\n")}"

      Rails.logger.error(message)

      render_sso_error(text: I18n.t("sso.unknown_error"), status: 500)
    end
  end
  
  def render_sso_error(status:, text:)
    @sso_error = text
    render plain: text, status: status
  end
end
