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

ActiveRecord::Schema[7.0].define(version: 2025_07_26_111346) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_charges", force: :cascade do |t|
    t.bigint "power_supply_plan_id"
    t.integer "amp", null: false
    t.decimal "price", precision: 6, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["power_supply_plan_id"], name: "index_basic_charges_on_power_supply_plan_id"
  end

  create_table "meter_rate_charges", force: :cascade do |t|
    t.bigint "power_supply_plan_id"
    t.integer "min_meter_rate", null: false
    t.integer "max_meter_rate"
    t.decimal "price", precision: 6, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["power_supply_plan_id"], name: "index_meter_rate_charges_on_power_supply_plan_id"
  end

  create_table "power_supply_plans", force: :cascade do |t|
    t.bigint "provider_id"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_power_supply_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
