require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "creating an order from tickets and mail" do
    concert = create(:concert, ticket_price: 1200).add_tickets(5)
    assert_equal 5, concert.tickets_remaining

    order = Order.for_tickets(concert.find_tickets(3), "john@example.com")

    assert_equal "john@example.com", order.email
    assert_equal 3, order.ticket_quantity
    assert_equal 3600, order.amount
    assert_equal 2, concert.tickets_remaining
  end

  test "tickets are released when an order is cancelled" do
    concert = create(:concert).add_tickets(10)
    order = concert.order_tickets("jane.doe@acme.org", 5)
    assert_equal 5, concert.tickets_remaining

    order.cancel!

    assert_equal 10, concert.tickets_remaining
    assert_nil Order.find_by(id: order.id)
  end
end
