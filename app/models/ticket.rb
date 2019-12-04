class Ticket < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :concert

  scope :available, -> { where(reserved_at: nil).where(order_id: nil) }

  def reserve!
    touch(:reserved_at)
  end

  def release!
    update!(reserved_at: nil)
  end

  def price
    concert.ticket_price
  end
end
