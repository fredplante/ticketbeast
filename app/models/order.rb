class Order < ApplicationRecord
  has_many :tickets
  belongs_to :concert, optional: true

  def self.for_tickets(tickets, email, amount)
    order = new(email: email, amount: amount)
    order.tickets = tickets
    order.save!
    order
  end

  def self.from_reservation(reservation)
    order = new(email: reservation.email, amount: reservation.total_cost)
    order.tickets = reservation.tickets
    order.save!
    order
  end

  def ticket_quantity
    tickets.count
  end
end
