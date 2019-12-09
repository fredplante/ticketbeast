require "test_helper"

class StripeAdapterTest < ActiveSupport::TestCase

  setup do
    VCR.insert_cassette("stripe")
    @last_charge = find_last_charge
  end

  teardown do
    VCR.eject_cassette
  end

  test "charges with a valid payment token are successful" do
    payment_gateway = PaymentGateway::StripeAdapter.new(ENV["STRIPE_SECRET_KEY"])

    payment_gateway.charge(2500, valid_token)

    assert_equal 1, new_charges.count
    assert_equal 2500, find_last_charge[:amount]
  end

  private

  def new_charges
    Stripe::Charge.list({
      limit: 1,
      ending_before: @last_charge
    }, { api_key: ENV["STRIPE_SECRET_KEY"] })[:data]
  end

  def valid_token
    Stripe::Token.create({
      card: {
        number: "4242424242424242",
        exp_month: 1,
        exp_year: Date.today.year + 1,
        cvc: "123",
      },
    }, { api_key: ENV["STRIPE_SECRET_KEY"] })[:id]
  end

  def find_last_charge
    Stripe::Charge.list({limit: 1}, { api_key: ENV["STRIPE_SECRET_KEY"] })[:data][0]
  end
end
