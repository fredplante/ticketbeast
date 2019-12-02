class Concert < ApplicationRecord
  has_many :orders
  has_many :tickets

  scope :published, ->{ where.not(published_at: nil) }

  def order_tickets(email, quantity)
    orders.build(email: email).tap do |order|
      ordered_tickets = tickets.take(quantity)
      order.tickets = ordered_tickets
      order.save
    end
  end

  def add_tickets(quantity)
    (1..quantity).each { tickets.create }
  end

  def tickets_remaining
    tickets.available.count
  end
end
