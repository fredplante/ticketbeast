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

    reservation = Reservation.new(@tickets, "john@example.com")

    assert_equal 3600, reservation.total_cost
  end

  test "reserved tickets are released when a reservation is cancelled" do
    reservation = Reservation.new(@tickets, "john@example.com")

    reservation.cancel!

    @tickets.each { |ticket| expect(ticket).to have_received(:release!) }
  end

  test "retrieving the reservation tickets" do
    reservation = Reservation.new(@tickets, "john@example.com")

    assert_equal @tickets, reservation.tickets
  end

  test "retrieving the reservation email" do
    reservation = Reservation.new([], "john@example.com")

    assert_equal "john@example.com", reservation.email
  end
end
