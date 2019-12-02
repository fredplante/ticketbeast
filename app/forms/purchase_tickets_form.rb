class PurchaseTicketsForm
  include ActiveModel::Model

  attr_accessor :email, :ticket_quantity, :payment_token

  validates :email, presence: true
end
