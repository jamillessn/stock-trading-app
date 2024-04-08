class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :action_type
      t.string :company_name
      t.string :shares
      t.float :cost_price

      t.timestamps
    end
  end
end
