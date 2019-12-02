class Concert < ApplicationRecord
  has_many :orders

  scope :published, ->{ where.not(published_at: nil) }

  def order_tickets(email, quantity)
    orders.create(email: email).tap do |order|
      (1..quantity).each { order.tickets.create }
    end
  end
end
