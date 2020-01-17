class PaymentProvidersController < ApplicationController
  before_action :set_payment_provider, only: [:show, :edit, :update, :destroy]
  before_action :ensure_member

  # GET /payment_providers
  # GET /payment_providers.json
  def index
    @payment_providers = PaymentProvider.all
  end

  # GET /payment_providers/1
  # GET /payment_providers/1.json
  def show
  end

  # GET /payment_providers/new
  def new
    @payment_provider = PaymentProvider.new
  end

  # GET /payment_providers/1/edit
  def edit
  end

  # POST /payment_providers
  # POST /payment_providers.json
  def create
    @payment_provider = PaymentProvider.new(payment_provider_params)

    respond_to do |format|
      if @payment_provider.save
        format.html { redirect_to settings_payments_path, notice: 'Payment provider was successfully created.' }
        format.json { render :show, status: :created, location: @payment_provider }
      else
        format.html { render :new }
        format.json { render json: @payment_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_providers/1
  # PATCH/PUT /payment_providers/1.json
  def update
    respond_to do |format|
      if @payment_provider.update(payment_provider_params)
        format.html { redirect_to settings_payments_path, notice: 'Payment provider was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_provider }
      else
        format.html { render :edit }
        format.json { render json: @payment_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_providers/1
  # DELETE /payment_providers/1.json
  def destroy
    @payment_provider.destroy
    respond_to do |format|
      format.html { redirect_to settings_payments_path, notice: 'Payment provider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_provider
      @payment_provider = PaymentProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_provider_params
      params.require(:payment_provider).permit(:label, :connected, :provider_type, :api_key)
    end
end
