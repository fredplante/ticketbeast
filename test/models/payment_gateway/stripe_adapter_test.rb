require "test_helper"

class StripeAdapterTest < ActiveSupport::TestCase
  test "charges with a valid payment token are successful" do
    VCR.use_cassette(cassette_name(class_name, name)) do
      last_charge = find_last_charge
      payment_gateway = create_payment_gateway
      payment_gateway.charge(2500, payment_gateway.valid_test_token)

      assert_equal 1, new_charges(last_charge).count
      assert_equal 2500, find_last_charge[:amount]
    end
  end

  test "charges win an invalid payment token fails" do
    VCR.use_cassette(cassette_name(class_name, name)) do
      last_charge = find_last_charge
      payment_gateway = PaymentGateway::StripeAdapter.new(ENV["STRIPE_SECRET_KEY"])

      assert_raises(PaymentGateway::PaymentFailedError) {
        payment_gateway.charge(2500, "invalid-payment-token")
      }
      assert_equal 0, new_charges(last_charge).count
    end
  end

  private

  def create_payment_gateway
    PaymentGateway::StripeAdapter.new(ENV["STRIPE_SECRET_KEY"])
  end

  def cassette_name(class_name, test_name)
    [class_name, test_name].map do |str|
      str.underscore.gsub(/[^A-Z]+/i, "_")
    end.join("/")
  end

  def new_charges(charge)
    Stripe::Charge.list({
      limit: 1,
      ending_before: charge
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
