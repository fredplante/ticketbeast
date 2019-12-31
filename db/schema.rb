# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_02_132503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "concerts", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle", null: false
    t.datetime "date", null: false
    t.integer "ticket_price", null: false
    t.string "venue", null: false
    t.string "venue_address", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
    t.text "additional_information", null: false
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string "confirmation_number", null: false
    t.string "email", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "concert_id", null: false
    t.datetime "reserved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concert_id"], name: "index_tickets_on_concert_id"
    t.index ["order_id"], name: "index_tickets_on_order_id"
  end

  add_foreign_key "tickets", "concerts"
  add_foreign_key "tickets", "orders"
end
