require "test_helper"

class StripeAdapterTest < ActiveSupport::TestCase
  include PaymentGatewayContractTest

  private

  def create_payment_gateway
    PaymentGateway::StripeAdapter.new(ENV["STRIPE_SECRET_KEY"])
  end
end
