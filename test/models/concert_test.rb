require "test_helper"

class ConcertTest < ActiveSupport::TestCase

  test "concert with a published date are published" do
    published_concert_1 = create(:concert, published_at: 2.weeks.ago)
    published_concert_2 = create(:concert, published_at: 1.week.ago)
    unpublished_concert = create(:concert, published_at: nil)

    published_concerts = Concert.published

    assert_includes published_concerts, published_concert_1
    assert_includes published_concerts, published_concert_2
    refute_includes published_concerts, unpublished_concert
  end

  test "can order concert tickets" do
    concert = create(:concert).add_tickets(3);

    order = concert.order_tickets("john.doe@acme.org", 3)
    assert_equal "john.doe@acme.org", order.email
    assert_equal 3, order.ticket_quantity
  end

  test "can add tickets" do
    concert = create(:concert)

    concert.add_tickets(50);

    assert_equal 50, concert.tickets_remaining
  end

  test "tickets_remaining does not include tickets associated with an order" do
    concert = create(:concert).add_tickets(50)

    concert.order_tickets("john.doe@acme.org", 30)

    assert_equal 20, concert.tickets_remaining
  end

  test "trying to purchase more tickets than remains throws an exception" do
    concert = create(:concert).add_tickets(10)

    assert_raises(Concert::NotEnoughTicketsError) {
      concert.order_tickets("john.doe@acme.org", 11)
    }

    refute concert.has_order_for?("john.doe@acme.org")
    assert_equal 10, concert.tickets_remaining
  end

  test "cannot order tickets that have been already purchased" do
    concert = create(:concert).add_tickets(10)
    concert.order_tickets("john.doe@acme.org", 8)

    assert_raises(Concert::NotEnoughTicketsError) {
      concert.order_tickets("jane.doe@acme.org", 3)
    }

    refute concert.has_order_for?("jane.doe@acme.org")
    assert_equal 2, concert.tickets_remaining
  end

  test "can reserve available tickets" do
    concert = create(:concert).add_tickets(3)
    assert_equal 3, concert.tickets_remaining

    reserved_tickets = concert.reserve_tickets(2)

    assert_equal 2, reserved_tickets.count
    assert_equal 1, concert.tickets_remaining
  end

  test "cannot reserve tickets that have already been purchased" do
    concert = create(:concert).add_tickets(3)
    concert.order_tickets("john.doe@acme.org", 2)

    assert_raises(Concert::NotEnoughTicketsError) { concert.reserve_tickets(2) }
    assert_equal 1, concert.tickets_remaining
  end

  test "cannot reserve tickets that have already been reserved" do
    concert = create(:concert).add_tickets(3)
    concert.reserve_tickets(2)

    assert_raises(Concert::NotEnoughTicketsError) { concert.reserve_tickets(2) }
    assert_equal 1, concert.tickets_remaining
  end
end
