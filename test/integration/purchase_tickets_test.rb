require "test_helper"

class PurchaseTicketsTest < ActionDispatch::IntegrationTest
  test "customer can purchase concert tickets" do
    concert = create(:concert, ticket_price: 3250)

    post "/concerts/#{concert.id}/orders", params: { email: "john@example.com",
                                                     ticket_quantity: 3,
                                                     payment_token: PaymentGateway::Base.valid_test_token }, as: :json

    order = concert.orders.where(email: "john@example.com").first
    refute_nil order
    assert_equal 3, order.ticket_quantity
  end
end
