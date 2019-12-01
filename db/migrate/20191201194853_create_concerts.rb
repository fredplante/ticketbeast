class CreateConcerts < ActiveRecord::Migration[5.2]
  def change
    create_table :concerts do |t|
    	t.string :title
    	t.string :subtitle
    	t.datetime :date
    	t.integer :ticket_price
    	t.string :venue
    	t.string :venue_address
    	t.string :city
    	t.string :state
    	t.string :zip
    	t.text :additional_information
      t.timestamps
    end
  end
end
