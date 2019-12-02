class PurchaseTicketsForm
  include ActiveModel::Model

  attr_accessor :email, :ticket_quantity, :payment_token

  validates :email, presence: true
  validates :email,  format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, allow_blank: true
  validates :ticket_quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :payment_token, presence: true
end
