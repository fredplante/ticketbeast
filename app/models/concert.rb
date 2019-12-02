class Concert < ApplicationRecord

  has_many :orders

  scope :published, ->{ where.not(published_at: nil) }
end
