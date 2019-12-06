class Reservation

  attr_reader :tickets, :email

  def initialize(tickets, email)
    @tickets = tickets
    @email = email
  end

  def total_cost
    tickets.map(&:price).sum
  end

  def complete!(payment_gateway, payment_token)
    payment_gateway.charge(total_cost, payment_token)
    Order.for_tickets(tickets, email, total_cost)
  end

  def cancel!
    tickets.each { |ticket| ticket.release! }
  end
end
