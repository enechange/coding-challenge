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

ActiveRecord::Schema.define(version: 2022_10_22_234839) do

  create_table "basic_charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "contract_amperage", null: false
    t.float "charge_unit_price", null: false
    t.bigint "electricity_rate_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electricity_rate_plan_id", "contract_amperage"], name: "plan_id_and_contract_amperage", unique: true
  end

  create_table "electric_power_providers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "electricity_rate_plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "electric_power_provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electric_power_provider_id"], name: "fk_rails_f6ecb975ea"
    t.index ["name", "electric_power_provider_id"], name: "name_and_provider_id", unique: true
  end

  create_table "usage_charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.float "charge_unit_price", null: false
    t.integer "minimum_usage", null: false
    t.integer "max_usage"
    t.bigint "electricity_rate_plan_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["electricity_rate_plan_id"], name: "fk_rails_d0478968c3"
    t.index ["minimum_usage", "max_usage", "electricity_rate_plan_id"], name: "minimum_and_max_and_plan_id", unique: true
  end

  add_foreign_key "basic_charges", "electricity_rate_plans"
  add_foreign_key "electricity_rate_plans", "electric_power_providers"
  add_foreign_key "usage_charges", "electricity_rate_plans"
end
