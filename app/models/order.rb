class Order < ApplicationRecord
  has_many :tickets
  belongs_to :concert, optional: true

  def self.for_tickets(tickets, email, amount)
    order = new(email: email, amount: amount)
    order.tickets = tickets
    order.save!
    order
  end

  def ticket_quantity
    tickets.count
  end
end
