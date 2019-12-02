class CreateConcerts < ActiveRecord::Migration[5.2]
  def change
    create_table :concerts do |t|
    	t.string :title, null: false
    	t.string :subtitle, null: false
    	t.datetime :date, null: false
    	t.integer :ticket_price, null: false
    	t.string :venue, null: false
    	t.string :venue_address, null: false
    	t.string :city, null: false
    	t.string :state, null: false
    	t.string :zip, null: false
    	t.text :additional_information, null: false
      t.datetime :published_at
      t.timestamps
    end
  end
end
