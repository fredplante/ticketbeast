require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @tickets = [
      instance_double("Ticket").as_null_object,
      instance_double("Ticket").as_null_object,
      instance_double("Ticket").as_null_object
    ]
  end

  test "calculating the total cost" do
    @tickets.each { |ticket| expect(ticket).to receive(:price).and_return(1200) }

    reservation = Reservation.new(@tickets)

    assert_equal 3600, reservation.total_cost
  end

  test "reserved tickets are released when a reservation is cancelled" do
    reservation = Reservation.new(@tickets)

    reservation.cancel!

    @tickets.each { |ticket| expect(ticket).to have_received(:release!) }
  end
end
