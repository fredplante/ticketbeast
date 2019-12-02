class Concert::OrdersController < ApplicationController
  before_action :set_concert

  def create
    payment_gateway.charge(params[:ticket_quantity] * @concert.ticket_price, params[:payment_token])
    @concert.order_tickets(params[:email], params[:ticket_quantity])

    render json: {}, status: :created
  end

  private

  def set_concert
    @concert = Concert.find(params[:concert_id])
  end

  def payment_gateway
    @payment_gateway ||= PaymentGateway.create_adapter
  end
end
