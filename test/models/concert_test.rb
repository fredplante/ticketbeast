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

    order = concert.order_tickets("john.doa@acme.org", 3)
    assert_equal "john.doa@acme.org", order.email
    assert_equal 3, order.tickets.count
  end
end
