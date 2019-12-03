class Order < ApplicationRecord
  has_many :tickets

  def ticket_quantity
    tickets.count
  end

  def cancel!
    tickets.each { |ticket| ticket.release! }
    destroy
  end
end
