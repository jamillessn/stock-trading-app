class Stock < ApplicationRecord
  belongs_to :user_id
  validate :shares, comparison: { greater_than_or_equal_to: 0 }
end
