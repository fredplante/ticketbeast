module PaymentGateway
  class StripeAdapter

    def initialize(api_key)
      @api_key = api_key
    end

    def charge(amount, token)
      Stripe::Charge.create({
        amount: amount,
        currency: "eur",
        source: token
      }, { api_key: @api_key })
    end
  end
end
