class AddDefaultBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :balance, :float
  end
end
