class Concert::OrdersController < ApplicationController
  before_action :set_concert

  def create
    form = PurchaseTicketsForm.new(purchase_tickets_params)
    if form.valid?
      begin
        tickets = @concert.find_tickets(params[:ticket_quantity])
        payment_gateway.charge(params[:ticket_quantity] * @concert.ticket_price, params[:payment_token])

        @order = @concert.create_order(params[:email], tickets)

        render :create, status: :created
      rescue Concert::NotEnoughTicketsError => error
        render json: { error: error.message }, status: :unprocessable_entity
      rescue PaymentGateway::PaymentFailedError => error
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
