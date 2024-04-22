class AddDefaultBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :default_balance, :decimal
  end
end
