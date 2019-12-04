class Reservation

  def initialize(tickets)
    @tickets = tickets
  end

  def total_cost
    @tickets.map(&:price).sum
  end

  def cancel!
    @tickets.each { |ticket| ticket.release! }
  end
end
