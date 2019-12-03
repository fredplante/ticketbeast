require "test_helper"

class TicketTest < ActiveSupport::TestCase
  test "a ticket can be released" do
    concert = create(:concert)
    concert.add_tickets(1)
    order = concert.order_tickets("jane.doe@acme.org", 1)
    ticket = order.tickets.first
    assert_equal concert.id, ticket.concert_id

    ticket.release!

    assert_nil ticket.reload.order_id
  end
end
