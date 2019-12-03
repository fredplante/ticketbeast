class Order < ApplicationRecord
  has_many :tickets
  belongs_to :concert

  def ticket_quantity
    tickets.count
  end

  def cancel!
    tickets.each { |ticket| ticket.release! }
    destroy
  end
end
