class AddMissingColumnsToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_reference :transactions, :trader, null: false, foreign_key: true
    add_reference :transactions, :stock, null: false, foreign_key: true
    add_column :transactions, :price, :decimal
  end
end
