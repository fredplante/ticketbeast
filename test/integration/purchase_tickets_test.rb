require "test_helper"

class PurchaseTicketsTest < ActionDispatch::IntegrationTest
  test "customer can purchase concert tickets" do
    concert = create(:concert, ticket_price: 3250)
    payment_gateway = PaymentGateway::FakeAdapter.new
    PaymentGateway.expects(:create_adapter).returns(payment_gateway)

    url = "/concerts/#{concert.id}/orders"
    params = { email: "john@example.com", ticket_quantity: 3, payment_token: payment_gateway.valid_test_token }
    post url, params: params, as: :json

    assert_response :created

    assert_equal 9750, payment_gateway.total_charges

    order = concert.orders.where(email: "john@example.com").first
    refute_nil order
    assert_equal 3, order.tickets.count
  end
end
