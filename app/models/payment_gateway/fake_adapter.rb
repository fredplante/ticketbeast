module PaymentGateway
  class FakeAdapter
    def initialize
      @charges = []
    end

    def charge(amount, token)
      raise PaymentFailedError.new("Invalid token") if token != valid_test_token

      @charges << amount
    end

    def total_charges
      @charges.reduce(:+)
    end

    def valid_test_token
      "valid-test-token"
    end
  end
end
