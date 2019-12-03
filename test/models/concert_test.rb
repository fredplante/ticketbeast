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
    concert = create(:concert)
    concert.add_tickets(3);

    order = concert.order_tickets("john.doe@acme.org", 3)
    assert_equal "john.doe@acme.org", order.email
    assert_equal 3, order.tickets.count
  end

  test "can add tickets" do
    concert = create(:concert)

    concert.add_tickets(50);

    assert_equal 50, concert.tickets_remaining
  end

  test "tickets_remaining does not include tickets associated with an order" do
    concert = create(:concert)
    concert.add_tickets(50)

    concert.order_tickets("john.doe@acme.org", 30)

    assert_equal 20, concert.tickets_remaining
  end

  test "trying to purchase more tickets than remains throws an exception" do
    concert = create(:concert)
    concert.add_tickets(10)

    assert_raises(Concert::NotEnoughTicketsError) {
      concert.order_tickets("john.doe@acme.org", 11)
    }

    order = Order.where(email: "john.doe@acme.org").first
    assert_nil order
    assert_equal 10, concert.tickets_remaining
  end

  test "cannot order tickets that have been already purchased" do
    concert = create(:concert)
    concert.add_tickets(10)
    concert.order_tickets("john.doe@acme.org", 8)

    assert_raises(Concert::NotEnoughTicketsError) {
      concert.order_tickets("jane.doe@acme.org", 3)
    }

    jane_order = Order.where(email: "jane.doe@acme.org").first
    assert_nil jane_order
    assert_equal 2, concert.tickets_remaining
  end
end
