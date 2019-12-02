require "test_helper"

class FakeAdapterTest < ActiveSupport::TestCase
  test "charges with a valid payment token are successful" do
    payment_gateway = PaymentGateway::FakeAdapter.new

    payment_gateway.charge(2500, payment_gateway.valid_test_token)

    assert_equal 2500, payment_gateway.total_charges
  end

  test "charges win an invalid payment token fails" do
    payment_gateway = PaymentGateway::FakeAdapter.new

    assert_raises(PaymentGateway::PaymentFailedError) {
      payment_gateway.charge(2500, "invalid-payment-token")
    }
  end
end
