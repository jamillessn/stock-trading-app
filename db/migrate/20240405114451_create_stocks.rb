class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      t.integer :shares
      t.float :cost_price

      t.timestamps
    end
  end
end
