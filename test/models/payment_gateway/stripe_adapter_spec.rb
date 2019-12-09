require "test_helper"

class StripeAdapterTest < ActiveSupport::TestCase

  test "charges with a valid payment token are successful" do
    payment_gateway = PaymentGateway::StripeAdapter.new

    token = Stripe::Token.create({
      card: {
        number: "4242424242424242",
        exp_month: 1,
        exp_year: Date.today.year + 1,
        cvc: "123",
      },
    }, { api_key: ENV["STRIPE_SECRET_KEY"] })[:id]

    payment_gateway.charge(2500, token)

    last_charge = Stripe::Charge.list({limit: 1}, { api_key: ENV["STRIPE_SECRET_KEY"] })[:data][0]
  end
end
