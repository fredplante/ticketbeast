class Concert < ApplicationRecord

  class NotEnoughTicketsError < StandardError; end

  has_many :orders
  has_many :tickets

  scope :published, ->{ where.not(published_at: nil) }

  def has_order_for?(customer_email)
    orders_for(customer_email).exists?
  end

  def orders_for(customer_email)
    orders.where(email: customer_email)
  end

  def order_tickets(email, quantity)
    orders.build(email: email, amount: ticket_price * quantity).tap do |order|
      ordered_tickets = tickets.available.take(quantity)
      if ordered_tickets.count < quantity
        raise NotEnoughTicketsError.new("Not enough tickets available")
      end
      order.tickets = ordered_tickets
      order.save
    end
  end

  def add_tickets(quantity)
    (1..quantity).each { tickets.create }
    self
  end

  def tickets_remaining
    tickets.available.count
  end
end
