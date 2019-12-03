require "test_helper"

class PurchaseTicketsTest < ActionDispatch::IntegrationTest
  setup do
    @payment_gateway = PaymentGateway::FakeAdapter.new
  end

  test "customer can purchase tickets to a published concert" do
    concert = create(:concert, :published, ticket_price: 3250).add_tickets(3)
    PaymentGateway.expects(:create_adapter).returns(@payment_gateway)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 3,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_response :created

    assert_json_response_includes({
      email: "john@example.com",
      ticket_quantity: 3,
      amount: 9750
    })

    assert_equal 9750, @payment_gateway.total_charges
    assert concert.has_order_for?("john@example.com")
    assert_equal 3, concert.orders_for("john@example.com").first.ticket_quantity
  end

  test "an order is not created if payment fails" do
    concert = create(:concert, :published, ticket_price: 3250).add_tickets(3)
    PaymentGateway.expects(:create_adapter).returns(@payment_gateway)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 3, payment_token: "invalid-payment-token"
    })

    assert_response :unprocessable_entity
    refute concert.has_order_for?("john@example.com")
  end

  test "cannot purchase tickets to an unpublished concert" do
    concert = create(:concert, :unpublished).add_tickets(3)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 3,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_response :not_found
    refute concert.has_order_for?("john@example.com")
    assert_equal 0, @payment_gateway.total_charges
  end

  test "cannot purchase more ticket than remain" do
    concert = create(:concert, :published).add_tickets(50)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 51,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_response :unprocessable_entity
    refute concert.has_order_for?("john@example.com")
    assert_equal 0, @payment_gateway.total_charges
    assert_equal 50, concert.tickets_remaining
  end

  test "email is required to purchase tickets" do
    concert = create(:concert, :published)

    order_tickets(concert, {
      ticket_quantity: 3, payment_token: @payment_gateway.valid_test_token })

    assert_validation_error("email")
  end

  test "email must be valid to purchase tickets" do
    concert = create(:concert, :published)

    order_tickets(concert, {
      email: "not-a-valid-email", ticket_quantity: 3,
                                    payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("email")
  end

  test "ticket quantity is required to purchase tickets" do
    concert = create(:concert, :published)

    order_tickets(concert, {
      email: "john@example.com", payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("ticket_quantity")
  end

  test "ticket quantity must be at least 1 to purchase tickets" do
    concert = create(:concert, :published)

    order_tickets(concert, {
      email: "john@example.com", ticket_quantity: 0,
                                   payment_token: @payment_gateway.valid_test_token
    })

    assert_validation_error("ticket_quantity")
  end

  test "payment_token is required" do
    concert = create(:concert, :published)

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
