class Order < ApplicationRecord
  has_many :tickets

  def cancel!
    tickets.each { |ticket| ticket.release! }
    destroy
  end
end
