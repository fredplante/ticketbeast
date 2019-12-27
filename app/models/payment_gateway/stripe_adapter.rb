module PaymentGateway
  class StripeAdapter

    def initialize(api_key = ENV["STRIPE_SECRET_KEY"])
      @api_key = api_key
    end

    def charge(amount, token)
      Stripe::Charge.create({
        amount: amount,
        currency: "eur",
        source: token
      }, { api_key: @api_key })
    rescue Stripe::InvalidRequestError => e
      raise PaymentFailedError.new("Invalid token")
    end

    def valid_test_token
      Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 1,
          exp_year: Date.today.year + 1,
          cvc: "123",
        },
      }, { api_key: @api_key })[:id]
    end

    def new_charges_during(&block)
      latest_charge = last_charge
      yield
      new_charges_since(latest_charge)
    end

    private

    def last_charge
      Stripe::Charge.list({limit: 1}, { api_key: @api_key })[:data][0]
    end

    def new_charges_since(charge = nil)
      Stripe::Charge.list({
        ending_before: charge ? charge[:id] : nil
      }, { api_key: @api_key })[:data]
    end
  end
end
