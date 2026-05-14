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

ActiveRecord::Schema[7.0].define(version: 2026_05_14_000002) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ampere_based_rates", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "ampere", null: false
    t.decimal "rate", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "ampere"], name: "index_ampere_based_rates_on_plan_id_and_ampere", unique: true
    t.index ["plan_id"], name: "index_ampere_based_rates_on_plan_id"
    t.check_constraint "ampere = ANY (ARRAY[10, 15, 20, 30, 40, 50, 60])", name: "ampere_based_rates_ampere_allowed"
    t.check_constraint "rate >= 0::numeric", name: "ampere_based_rates_rate_non_negative"
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id", "name"], name: "index_plans_on_provider_id_and_name", unique: true
    t.index ["provider_id"], name: "index_plans_on_provider_id"
    t.index ["slug"], name: "index_plans_on_slug", unique: true
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_providers_on_name", unique: true
  end

  create_table "usage_based_rates", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "kilowatt_hour_low", null: false
    t.integer "kilowatt_hour_high", null: false
    t.decimal "rate", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "kilowatt_hour_low", "kilowatt_hour_high"], name: "index_usage_based_rates_on_plan_and_range", unique: true
    t.index ["plan_id"], name: "index_usage_based_rates_on_plan_id"
    t.check_constraint "kilowatt_hour_low < kilowatt_hour_high", name: "usage_based_rates_low_lt_high"
    t.check_constraint "kilowatt_hour_low >= 0", name: "usage_based_rates_low_non_negative"
    t.check_constraint "rate >= 0::numeric", name: "usage_based_rates_rate_non_negative"
  end

  add_foreign_key "ampere_based_rates", "plans"
  add_foreign_key "plans", "providers"
  add_foreign_key "usage_based_rates", "plans"
end
