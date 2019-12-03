require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  test "calculating the total cost" do
    concert = create(:concert, ticket_price: 1200).add_tickets(3)
    tickets = concert.find_tickets(3)

    reservation = Reservation.new(tickets)

    assert_equal 3600, reservation.total_cost
  end
end
