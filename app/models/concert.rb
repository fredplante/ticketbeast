class Concert < ApplicationRecord

  class NotEnoughTicketsError < StandardError; end

  has_many :tickets
  has_many :orders, through: :tickets

  scope :published, ->{ where.not(published_at: nil) }

  def reserve_tickets(quantity)
    find_tickets(quantity).each { |ticket| ticket.reserve! }
  end

  def has_order_for?(customer_email)
    orders_for(customer_email).exists?
  end

  def orders_for(customer_email)
    orders.where(email: customer_email)
  end

  def order_tickets(email, quantity)
    ordered_tickets = find_tickets(quantity)

    create_order(email, ordered_tickets)
  end

  def add_tickets(quantity)
    (1..quantity).each { tickets.create! }
    self
  end

  def tickets_remaining
    tickets.available.count
  end

  def create_order(email, tickets)
    Order.for_tickets(tickets, email, tickets.map(&:price).sum)
  end

  def find_tickets(quantity)
    found_tickets = tickets.available.take(quantity)

    if found_tickets.count < quantity
      raise NotEnoughTicketsError.new("Not enough tickets available")
    end

    found_tickets
  end
end
