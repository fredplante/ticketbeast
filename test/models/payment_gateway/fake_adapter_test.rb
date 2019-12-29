require "test_helper"

class FakeAdapterTest < ActiveSupport::TestCase
  include PaymentGatewayContractTest

  test "running a hook before the first charge" do
    payment_gateway = PaymentGateway::FakeAdapter.new
    callback_ran_count = 0

    payment_gateway.before_charge_callback = proc {
      callback_ran_count += 1
      payment_gateway.charge(2500, payment_gateway.valid_test_token)

      assert_equal 2500, payment_gateway.total_charges
    }

    payment_gateway.charge(2500, payment_gateway.valid_test_token)
    assert_equal 5000, payment_gateway.total_charges
    assert_equal 1, callback_ran_count
  end

  private

  def create_payment_gateway
    PaymentGateway::FakeAdapter.new
  end
end
