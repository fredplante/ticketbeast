class Ticket < ApplicationRecord
  scope :available, -> { where(order_id: nil) }

  def release!
    update!(order_id: nil)
  end
end
