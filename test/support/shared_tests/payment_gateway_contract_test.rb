module PaymentGatewayContractTest
  extend ActiveSupport::Concern

  included do
    test "charges with a valid payment token are successful" do
      VCR.use_cassette(cassette_name(class_name, name)) do
        payment_gateway = create_payment_gateway

        new_charges = payment_gateway.new_charges_during do
          payment_gateway.charge(2500, payment_gateway.valid_test_token)
        end

        assert_equal 1, new_charges.count
        assert_equal 2500, new_charges.sum
      end
    end

    test "can fetch charges created during a callback" do
      VCR.use_cassette(cassette_name(class_name, name)) do
        payment_gateway = create_payment_gateway

        payment_gateway.charge(2000, payment_gateway.valid_test_token)
        payment_gateway.charge(3000, payment_gateway.valid_test_token)

        new_charges = payment_gateway.new_charges_during do
          payment_gateway.charge(4000, payment_gateway.valid_test_token)
          payment_gateway.charge(5000, payment_gateway.valid_test_token)
        end

        assert_equal 2, new_charges.count
        assert_equal [5000, 4000], new_charges
      end
    end

    test "charges win an invalid payment token fails" do
      VCR.use_cassette(cassette_name(class_name, name)) do
        payment_gateway = create_payment_gateway

        new_charges = payment_gateway.new_charges_during do
          assert_raises(PaymentGateway::PaymentFailedError) {
            payment_gateway.charge(2500, "invalid-payment-token")
          }
        end

        assert_equal 0, new_charges.count
      end
    end
  end
end
