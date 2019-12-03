class Ticket < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :concert

  scope :available, -> { where(order_id: nil) }

  def reserve!
    touch(:reserved_at)
  end

  def release!
    update!(order_id: nil)
  end

  def price
    concert.ticket_price
  end
end
