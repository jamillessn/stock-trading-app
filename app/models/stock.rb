class Stock < ApplicationRecord

  has_many :transactions
  belongs_to :user

  validates :shares, numericality: true
  validates :shares, numericality: { greater_than_or_equal_to: 0 }
end
