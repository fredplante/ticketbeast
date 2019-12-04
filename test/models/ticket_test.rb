require "test_helper"

class TicketTest < ActiveSupport::TestCase
  test "a ticket can be reserved" do
    ticket = create(:ticket)
    assert_nil ticket.reserved_at

    ticket.reserve!

    refute_nil ticket.reload.reserved_at
  end

  test "a ticket can be released" do
    ticket = create(:ticket, :reserved)
    refute_nil ticket.reserved_at

    ticket.release!

    assert_nil ticket.reload.reserved_at
  end
end
