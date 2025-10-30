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

ActiveRecord::Schema[7.0].define(version: 2025_10_19_172807) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_charges", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "ampere", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "ampere"], name: "index_basic_charges_on_plan_id_and_ampere", unique: true
    t.index ["plan_id"], name: "index_basic_charges_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id", "code"], name: "index_plans_on_provider_id_and_code", unique: true
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_providers_on_code", unique: true
  end

  create_table "usage_charges", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.integer "from_kwh", null: false
    t.integer "to_kwh"
    t.decimal "unit_price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "from_kwh"], name: "index_usage_charges_on_plan_id_and_from_kwh", unique: true
    t.index ["plan_id"], name: "index_usage_charges_on_plan_id"
  end

  add_foreign_key "basic_charges", "plans"
  add_foreign_key "plans", "providers"
  add_foreign_key "usage_charges", "plans"
end
