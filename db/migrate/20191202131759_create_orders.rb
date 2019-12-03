class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :concert, foreign_key: true, null: false
      t.string :email, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
