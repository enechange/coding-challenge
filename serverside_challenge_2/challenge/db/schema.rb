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

ActiveRecord::Schema[7.0].define(version: 2024_10_27_072347) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_prices", force: :cascade do |t|
    t.integer "amperage", limit: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "amperage"], name: "index_basic_prices_on_plan_id_and_amperage", unique: true
    t.index ["plan_id"], name: "index_basic_prices_on_plan_id"
  end

  create_table "measured_rates", force: :cascade do |t|
    t.integer "electricity_usage_min", limit: 2, null: false
    t.integer "electricity_usage_max", limit: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_measured_rates_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id", "name"], name: "index_plans_on_provider_id_and_name", unique: true
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  add_foreign_key "basic_prices", "plans", on_delete: :cascade
  add_foreign_key "measured_rates", "plans", on_delete: :cascade
  add_foreign_key "plans", "providers", on_delete: :cascade
end
