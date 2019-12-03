class Order < ApplicationRecord
  has_many :tickets

  def cancel!
    tickets.update_all(order_id: nil)
    destroy
  end
end
