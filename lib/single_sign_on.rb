# frozen_string_literal: true

class SingleSignOn
  include Rails.application.routes.url_helpers

  class ParseError < RuntimeError; end
  class BlankExternalId < StandardError; end

  ACCESSORS = %i{
    email
    name
    groups
    avatar_url
    external_id
    nonce
    return_sso_url
  }

  FIXNUMS = []

  BOOLS = %i{
  }

  def self.nonce_expiry_time
    @nonce_expiry_time ||= 10.minutes
  end

  def self.nonce_expiry_time=(v)
    @nonce_expiry_time = v
  end

  attr_accessor(*ACCESSORS)
  attr_writer :sso_secret, :sso_url

  def self.sso_secret
    ENV["SSO_SECRET"]
  end

  def self.sso_url
    ENV["SSO_URL"]
  end
  
  def self.generate_sso(return_path = "/")
    sso = new
    sso.nonce = SecureRandom.hex
    sso.register_nonce(return_path)
    sso.return_sso_url = Rails.application.routes.url_helpers.root_url + "session/sso_login"
    sso
  end
  
  def register_nonce(return_path)
    if nonce
       Rails.cache.write(nonce_key, return_path, expires_in: 10.minutes)
    end
  end

  def nonce_valid?
    nonce && Rails.cache.read(nonce_key).present?
  end
  
  def nonce_key
    "SSO_NONCE_#{nonce}"
  end
  
  def return_path
    Rails.cache.read(nonce_key) || "/"
  end
  
  def expire_nonce!
    if nonce
      Rails.cache.delete nonce_key
    end
  end

  def self.parse(payload, sso_secret = nil)
    sso = new
    sso.sso_secret = sso_secret if sso_secret

    parsed = Rack::Utils.parse_query(payload)
    decoded = Base64.decode64(parsed["sso"])
    decoded_hash = Rack::Utils.parse_query(decoded)

    if sso.sign(parsed["sso"]) != parsed["sig"]
      diags = "\n\nsso: #{parsed["sso"]}\n\nsig: #{parsed["sig"]}\n\nexpected sig: #{sso.sign(parsed["sso"])}"
      if parsed["sso"] =~ /[^a-zA-Z0-9=\r\n\/+]/m
        raise ParseError, "The SSO field should be Base64 encoded, using only A-Z, a-z, 0-9, +, /, and = characters. Your input contains characters we don't understand as Base64, see http://en.wikipedia.org/wiki/Base64 #{diags}"
      else
        raise ParseError, "Bad signature for payload #{diags}"
      end
    end

    ACCESSORS.each do |k|
      puts "k: #{k}"
      if k == :groups
        puts "val: #{decoded_hash[k.to_s]}"
      end
      val = decoded_hash[k.to_s]
      val = val.to_i if FIXNUMS.include? k
      if BOOLS.include? k
        val = ["true", "false"].include?(val) ? val == "true" : nil
      end
      sso.public_send("#{k}=", val)
    end
    
    puts "SSO: #{sso.inspect}"

    sso
  end

  def diagnostics
    SingleSignOn::ACCESSORS.map { |a| "#{a}: #{public_send(a)}" }.join("\n")
  end

  def sso_secret
    @sso_secret || self.class.sso_secret
  end

  def sso_url
    @sso_url || self.class.sso_url
  end

  def sign(payload, secret = nil)
    secret = secret || sso_secret
    OpenSSL::HMAC.hexdigest("sha256", secret, payload)
  end

  def to_url(base_url = nil)
    base = "#{base_url || sso_url}"
    "#{base}#{base.include?('?') ? '&' : '?'}#{payload}"
  end

  def payload(secret = nil)
    payload = Base64.strict_encode64(unsigned_payload)
    "sso=#{CGI::escape(payload)}&sig=#{sign(payload, secret)}"
  end

  def unsigned_payload
    payload = {}

    ACCESSORS.each do |k|
      next if (val = public_send(k)) == nil
      payload[k] = val
    end

    Rack::Utils.build_query(payload)
  end
  
  def lookup_or_create_user
    external_id = self.external_id.to_s
    name = self.name
    email = self.email
    groups = self.groups
    avatar_url = self.avatar_url

    if external_id.blank?
      raise BlankExternalId
    end

    sso_record = SingleSignOnRecord.find_by(external_id: external_id)

    if sso_record && (user = sso_record.user)
      sso_record.last_payload = unsigned_payload
    else
      user = match_email_or_create_user
      sso_record = user.single_sign_on_record
    end
    
    user.email = email
    user.name = name
    
    if groups && (customer = Customer.find_by(group: groups.split(',')))
      user.groups = groups
      user.customer = customer
    end
    
    user.avatar_url = avatar_url
    
    user.save!

    sso_record.save!
    
    sso_record && sso_record.user
  end
  
  def match_email_or_create_user
    user = User.find_by_email(email)
    
    if !user
      user_params = {
        email: email,
        name: name,
        groups: groups,
        password: SecureRandom.urlsafe_base64
      }

      user = User.create!(user_params)

      Rails.logger.warn("New User (user_id: #{user.id}) Params: #{user_params} User Params: #{user.attributes} User Errors: #{user.errors.full_messages} Email: #{user.email}")
    end

    if user
      if sso_record = user.single_sign_on_record
        sso_record.last_payload = unsigned_payload
        sso_record.external_id = external_id
      else
        user.create_single_sign_on_record!(
          last_payload: unsigned_payload,
          external_id: external_id
        )
      end
    end

    user
  end
end
