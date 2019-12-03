class Order < ApplicationRecord
  has_many :tickets
  belongs_to :concert, optional: true

  def self.for_tickets(tickets, email)
    order = new(email: email, amount: tickets.map(&:price).sum)
    order.tickets = tickets
    order.save!
    order
  end

  def ticket_quantity
    tickets.count
  end

  def cancel!
    tickets.each { |ticket| ticket.release! }
    destroy
  end
end
