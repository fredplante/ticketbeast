class Concert::OrdersController < ApplicationController
  before_action :set_concert

  def create
    form = PurchaseTicketsForm.new(purchase_tickets_params)
    if form.valid?
    begin
      reservation = @concert.reserve_tickets(params[:ticket_quantity].to_i, params[:email])
      @order = reservation.complete!(payment_gateway, params[:payment_token])
      render :create, status: :created
    rescue Concert::NotEnoughTicketsError => error
      render json: { error: error.message }, status: :unprocessable_entity
    rescue PaymentGateway::PaymentFailedError => error
      reservation.cancel!
      render json: { error: error.message }, status: :unprocessable_entity
    end
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def set_concert
    @concert = Concert.published.find(params[:concert_id])
  end

  def payment_gateway
    @payment_gateway ||= PaymentGateway.create_adapter
  end

  def purchase_tickets_params
    params.permit(:email, :ticket_quantity, :payment_token)
  end

	rescue_from ActiveRecord::RecordNotFound do
		render json: { error: "concert not found" }, status: :not_found
	end
end
