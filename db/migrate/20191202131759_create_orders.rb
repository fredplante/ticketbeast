class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :confirmation_number, null: false
      t.string :email, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
