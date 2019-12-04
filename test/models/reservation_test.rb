require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  setup do
    @ticket_1 = instance_double("Ticket").as_null_object
    @ticket_2 = instance_double("Ticket").as_null_object
    @ticket_3 = instance_double("Ticket").as_null_object
    @tickets = [@ticket_1, @ticket_2, @ticket_3]
  end

  test "calculating the total cost" do
    allow(@ticket_1).to receive(:price).and_return(1200)
    allow(@ticket_2).to receive(:price).and_return(1200)
    allow(@ticket_3).to receive(:price).and_return(1200)

    reservation = Reservation.new(@tickets)

    assert_equal 3600, reservation.total_cost
  end

  test "reserved tickets are released when a reservation is cancelled" do
    reservation = Reservation.new(@tickets)

    reservation.cancel!

    expect(@ticket_1).to have_received(:release!).once
    expect(@ticket_2).to have_received(:release!).once
    expect(@ticket_3).to have_received(:release!).once
  end
end
