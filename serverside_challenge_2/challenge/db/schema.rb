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

ActiveRecord::Schema[7.0].define(version: 2025_02_01_033045) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_rates", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "ampere"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_basic_rates_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.bigint "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usage_rates", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "min_kwh"
    t.integer "max_kwh"
    t.decimal "price_per_kwh"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_usage_rates_on_plan_id"
  end

  add_foreign_key "basic_rates", "plans"
  add_foreign_key "plans", "providers"
  add_foreign_key "usage_rates", "plans"
end
