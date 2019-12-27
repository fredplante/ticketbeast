require "test_helper"

class FakeAdapterTest < ActiveSupport::TestCase
  test "can fetch charges created during a callback" do
    payment_gateway = create_payment_gateway

    payment_gateway.charge(2000, payment_gateway.valid_test_token)
    payment_gateway.charge(3000, payment_gateway.valid_test_token)

    new_charges = payment_gateway.new_charges_during do
      payment_gateway.charge(4000, payment_gateway.valid_test_token)
      payment_gateway.charge(5000, payment_gateway.valid_test_token)
    end

    assert_equal 2, new_charges.count
    assert_equal [4000, 5000], new_charges
  end

  test "charges with a valid payment token are successful" do
    payment_gateway = create_payment_gateway

    new_charges = payment_gateway.new_charges_during do
      payment_gateway.charge(2500, payment_gateway.valid_test_token)
    end

    assert_equal 1, new_charges.count
    assert_equal 2500, new_charges.sum
  end

  test "charges win an invalid payment token fails" do
    payment_gateway = PaymentGateway::FakeAdapter.new

    assert_raises(PaymentGateway::PaymentFailedError) {
      payment_gateway.charge(2500, "invalid-payment-token")
    }
  end

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
