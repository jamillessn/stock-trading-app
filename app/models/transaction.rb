class Transaction < ApplicationRecord
  belongs_to :user_id

  # validation (error - cant sell more than what user currently have in portfolio)
end
