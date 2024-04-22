class Stock < ApplicationRecord
<<<<<<< HEAD

  has_many :transactions
  belongs_to :user

  validates :shares, numericality: true
  validates :shares, numericality: { greater_than_or_equal_to: 0 }
=======
  belongs_to :user
  validate :shares, comparison: { greater_than_or_equal_to: 0 }
>>>>>>> e0e455d9deb01402d0aec578db5bfa8d2ec7a88c
end
