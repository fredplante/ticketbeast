class Concert::OrdersController < ApplicationController
  before_action :set_concert

  def create
    ticket_quantity = params[:ticket_quantity]
    payment_token = params[:payment_token]
    amount = ticket_quantity * @concert.ticket_price
    payment_gateway.charge(amount, payment_token)

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
