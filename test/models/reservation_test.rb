require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "calculating the total cost" do
    tickets = [
      stub(price: 1200),
      stub(price: 1200),
      stub(price: 1200),
    ]

    reservation = Reservation.new(tickets)

    assert_equal 3600, reservation.total_cost
  end
end
