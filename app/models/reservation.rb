class Reservation

  attr_reader :tickets, :email

  def initialize(tickets, email)
    @tickets = tickets
    @email = email
  end

  def total_cost
    tickets.map(&:price).sum
  end

  def cancel!
    tickets.each { |ticket| ticket.release! }
  end
end
