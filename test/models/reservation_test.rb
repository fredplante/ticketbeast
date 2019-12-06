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

  test "completing a reservation" do
    concert = create(:concert, ticket_price: 1200)
    tickets = create_list(:ticket, 3, concert: concert)
    reservation = Reservation.new(tickets, "john@example.com")
    payment_gateway = PaymentGateway::FakeAdapter.new

    order = reservation.complete!(payment_gateway,  payment_gateway.valid_test_token)

    assert_equal "john@example.com", order.email
    assert_equal 3, order.ticket_quantity
    assert_equal 3600, order.amount
    assert_equal 3600, payment_gateway.total_charges
  end
end
