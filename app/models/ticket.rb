class Ticket < ApplicationRecord
  scope :available, -> { where(order_id: nil) }
end
