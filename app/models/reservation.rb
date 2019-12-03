class Reservation

  def initialize(tickets)
    @tickets = tickets
  end

  def total_cost
    @tickets.map(&:price).sum
  end
end
