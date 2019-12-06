require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "creating an order from tickets and mail and amount" do
    concert = create(:concert).add_tickets(5)
    assert_equal 5, concert.tickets_remaining

    order = Order.for_tickets(concert.find_tickets(3), "john@example.com", 3600)

    assert_equal "john@example.com", order.email
    assert_equal 3, order.ticket_quantity
    assert_equal 3600, order.amount
    assert_equal 2, concert.tickets_remaining
  end

  test "creating an order from a reservation" do
    concert = create(:concert, ticket_price: 1200)
    tickets = create_list(:ticket, 3, concert: concert)
    reservation = Reservation.new(tickets, "john@example.com")

    order = Order.from_reservation(reservation)

    assert_equal "john@example.com", order.email
    assert_equal 3, order.ticket_quantity
    assert_equal 3600, order.amount
  end
end
