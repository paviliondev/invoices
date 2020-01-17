class PaymentReceiversController < ApplicationController
  before_action :set_payment_receiver, only: [:show, :edit, :update, :destroy]

  # GET /payment_receivers
  # GET /payment_receivers.json
  def index
    @payment_receivers = PaymentReceiver.all
  end

  # GET /payment_receivers/1
  # GET /payment_receivers/1.json
  def show
  end

  # GET /payment_receivers/new
  def new
    @payment_receiver = PaymentReceiver.new
  end

  # GET /payment_receivers/1/edit
  def edit
  end

  # POST /payment_receivers
  # POST /payment_receivers.json
  def create
    @payment_receiver = PaymentReceiver.new(payment_receiver_params)

    respond_to do |format|
      if @payment_receiver.save
        format.html { redirect_to settings_payments_path, notice: 'Payment receiver was successfully created.' }
        format.json { render :show, status: :created, location: @payment_receiver }
      else
        format.html { render :new }
        format.json { render json: @payment_receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payment_receivers/1
  # PATCH/PUT /payment_receivers/1.json
  def update
    respond_to do |format|
      if @payment_receiver.update(payment_receiver_params)
        format.html { redirect_to settings_payments_path, notice: 'Payment receiver was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_receiver }
      else
        format.html { render :edit }
        format.json { render json: @payment_receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment_receivers/1
  # DELETE /payment_receivers/1.json
  def destroy
    @payment_receiver.destroy
    respond_to do |format|
      format.html { redirect_to settings_payments_path, notice: 'Payment receiver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_receiver
      @payment_receiver = PaymentReceiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_receiver_params
      params.require(:payment_receiver).permit(:label, :payment_provider_id, :receiver_type, :currency, :instructions)
    end
end
