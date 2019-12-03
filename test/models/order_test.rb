require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "tickets are released when an order is cancelled" do
    concert = create(:concert).add_tickets(10)
    order = concert.order_tickets("jane.doe@acme.org", 5)
    assert_equal 5, concert.tickets_remaining

    order.cancel!

    assert_equal 10, concert.tickets_remaining
    assert_nil Order.find_by(id: order.id)
  end
end
