class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_invoice, only: [:new, :create]
  before_action :ensure_member, only: [:edit, :update, :destroy]

  # GET /payments
  def index
    @payments = Payment.all
  end

  # GET /payments/1
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
  end

  # GET /payments/1/edit
  def edit
    @invoices = Invoice.all
  end

  # POST /payments
  def create
    p_params = current_user.is_member? ? member_payment_params : payment_params
    @payment = Payment.new(p_params)
    
    @payment.amount = @invoice.gross_amount if @payment.amount.blank?
    @payment.date = Date.new if @payment.date.blank?

    respond_to do |format|
      if @payment.save
        format.html {
          redirect_to invoice_url(@invoice) #"/invoices/#{@invoice.id}/payments/#{@payment.id}"
        }
      else
        format.html { render :new, notice: @payment.errors }
      end
    end
  end

  # PATCH/PUT /payments/1
  def update
    respond_to do |format|
      if @payment.update(member_payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /payments/1
  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
    end
  end

  private
    def set_payment
      @payment = Payment.find(params[:id])
    end
    
    def set_invoice
      @invoice = Invoice.find(params[:invoice_id])
    end

    def member_payment_params
      params.permit(:invoice_id, :date, :amount, :notes)
    end
    
    def payment_params
      params.permit(:invoice_id, :notes)
    end
end
