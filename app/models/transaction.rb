class Transaction < ApplicationRecord
  belongs_to :user_id

  def self.buy_shares(current_user,transaction_attributes)
    ActiveRecord::Base.transaction do
      transaction = current_user.transactions.build(transaction_attributes)
      transaction.total_amount = transaction_attributes[:number_of_shares] * transaction_attributes[:price_per_share]
      transaction.save!

      current_user.balance -= transaction.total_amount
      current_user.save!
      
      current_user.transactions.create!(transaction_attributes)

      #subtract funds
      current_user.update!(balance: current_user.balance - transaction.total_amount)

      stock = current_user.stocks.find_or_create_by(stock_symbol: transaction_params[:stock_symbol])
      stock.shares += transaction_attributes[:number_of_shares]
      stock.save!
      
    end
  end

  def self.sell_shares(current_user,transaction_attributes)
    ActiveRecord::Base.transaction do
      current_user.transactions.create!(transaction_attributes)

      #add funds
      current_user.update!(balance: current_user.balance + transaction.total_amount)

      stock = current_user.stocks.find_or_create_by(stock_symbol: transaction_params[:stock_symbol])
      stock.shares -= transaction_attributes[:number_of_shares]
      stock.save!
    end
  end
end
