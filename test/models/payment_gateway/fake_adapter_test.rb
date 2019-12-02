require "test_helper"

module PaymentGateway
  class FakeAdapterTest < ActiveSupport::TestCase
    test "charges with a valid payment token are successful" do
      payment_gateway = PaymentGateway::FakeAdapter.new

      payment_gateway.charge(2500, payment_gateway.valid_test_token)

      assert_equal 2500, payment_gateway.total_charges
    end
  end
end
