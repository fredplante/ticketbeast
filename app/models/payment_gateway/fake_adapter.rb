module PaymentGateway
  class FakeAdapter
    extend ActiveModel::Callbacks
    define_model_callbacks :charge

    attr_accessor :before_charge_callback

    before_charge :run_before_charge_callback

    def initialize
      @charges = []
    end

    def charge(amount, token)
      run_callbacks :charge do
        raise PaymentFailedError.new("Invalid token") if token != valid_test_token

        @charges << amount
      end
    end

    def total_charges
      @charges.reduce(0, :+)
    end

    def valid_test_token
      "valid-test-token"
    end

    private

    def run_before_charge_callback
      return unless before_charge_callback.is_a? Proc

      before_charge_callback.call
    end
  end
end
