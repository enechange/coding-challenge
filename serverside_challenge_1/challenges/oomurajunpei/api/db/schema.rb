# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_12_185731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_rates", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.integer "ampere", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_basic_rates_on_provider_id"
  end

  create_table "pay_per_use_rates", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.float "unit_price", null: false
    t.integer "min_electricity_usage"
    t.integer "max_electricity_usage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_pay_per_use_rates_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "plan_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "basic_rates", "providers"
  add_foreign_key "pay_per_use_rates", "providers"
end
