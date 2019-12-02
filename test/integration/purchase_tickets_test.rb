require "test_helper"

class PurchaseTicketsTest < ActionDispatch::IntegrationTest
  setup do
    @payment_gateway = PaymentGateway::FakeAdapter.new
  end

  test "customer can purchase concert tickets" do
    concert = create(:concert, ticket_price: 3250)
    PaymentGateway.expects(:create_adapter).returns(@payment_gateway)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 3,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_response :created
    assert_equal 9750, @payment_gateway.total_charges

    order = concert.orders.where(email: "john@example.com").first
    refute_nil order
    assert_equal 3, order.tickets.count
  end

  test "an order is not created if payment fails" do
    concert = create(:concert, ticket_price: 3250)
    PaymentGateway.expects(:create_adapter).returns(@payment_gateway)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 3,
                                   payment_token: "invalid-payment-token"
    })

    assert_response :unprocessable_entity
    order = concert.orders.where(email: "john@example.com").first
    assert_nil order
  end

  test "email is required to purchase tickets" do
    concert = create(:concert)

    order_tickets(concert, {
      ticket_quantity: 3, payment_token: @payment_gateway.valid_test_token })

    assert_validation_error("email")
  end

  test "email must be valid to purchase tickets" do
    concert = create(:concert)

    order_tickets(concert, {
      email: "not-a-valid-email", ticket_quantity: 3,
                                    payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("email")
  end

  test "ticket quantity is required to purchase tickets" do
    concert = create(:concert)

    order_tickets(concert, {
      email: "john@example.com", payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("ticket_quantity")
  end

  test "ticket quantity must be at least 1 to purchase tickets" do
    concert = create(:concert)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 0,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("ticket_quantity")
  end

  test "payment_token is required" do
    concert = create(:concert)

    order_tickets(concert, { email: "john@example.com", ticket_quantity: 1 })

    assert_validation_error("payment_token")
  end

  private

  def assert_validation_error(attribute)
    assert_response :unprocessable_entity
    assert JSON.parse(response.body).has_key? attribute
  end

  def order_tickets(concert, params)
    post "/concerts/#{concert.id}/orders", params: params, as: :json
  end
end
