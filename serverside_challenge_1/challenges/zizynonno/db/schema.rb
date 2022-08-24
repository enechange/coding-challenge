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

ActiveRecord::Schema.define(version: 2022_08_23_110819) do

  create_table "basic_rates", force: :cascade do |t|
    t.integer "ampere", null: false
    t.decimal "price", precision: 6, scale: 2, null: false
    t.integer "electricity_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electricity_plan_id"], name: "index_basic_rates_on_electricity_plan_id"
  end

  create_table "electric_power_companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "electricity_plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "electric_power_company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electric_power_company_id"], name: "index_electricity_plans_on_electric_power_company_id"
  end

  create_table "meter_rates", force: :cascade do |t|
    t.integer "min_usage", null: false
    t.integer "max_usage"
    t.decimal "price", precision: 6, scale: 2, null: false
    t.integer "electricity_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electricity_plan_id"], name: "index_meter_rates_on_electricity_plan_id"
  end

  add_foreign_key "basic_rates", "electricity_plans"
  add_foreign_key "electricity_plans", "electric_power_companies"
  add_foreign_key "meter_rates", "electricity_plans"
end
