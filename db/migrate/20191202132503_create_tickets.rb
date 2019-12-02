class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :order, foreign_key: true
      t.references :concert, foreign_key: true, null: false
      t.timestamps
    end
  end
end
