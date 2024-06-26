class AddHoldingsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
