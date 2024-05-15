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

ActiveRecord::Schema[7.0].define(version: 2024_05_14_140359) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_rates", force: :cascade do |t|
    t.bigint "electricity_plan_id", null: false
    t.integer "amperage"
    t.decimal "rate", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electricity_plan_id"], name: "index_basic_rates_on_electricity_plan_id"
  end

  create_table "electricity_plans", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_electricity_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usage_rates", force: :cascade do |t|
    t.bigint "electricity_plan_id", null: false
    t.integer "limit_kwh"
    t.decimal "rate", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["electricity_plan_id"], name: "index_usage_rates_on_electricity_plan_id"
  end

  add_foreign_key "basic_rates", "electricity_plans"
  add_foreign_key "electricity_plans", "providers"
  add_foreign_key "usage_rates", "electricity_plans"
end
