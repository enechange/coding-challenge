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

ActiveRecord::Schema[7.0].define(version: 2023_04_07_010614) do
  create_table "api_v1_basic_charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "ampere"
    t.decimal "charge", precision: 10, scale: 2
    t.bigint "api_v1_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_v1_plan_id"], name: "index_api_v1_basic_charges_on_api_v1_plan_id"
  end

  create_table "api_v1_companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_v1_plans", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "api_v1_company_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_v1_company_id"], name: "index_api_v1_plans_on_api_v1_company_id"
  end

  create_table "api_v1_usage_charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "from_khw"
    t.integer "to_khw"
    t.decimal "charge", precision: 10, scale: 2
    t.decimal "stacked_charge", precision: 10, scale: 2
    t.bigint "api_v1_plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_v1_plan_id"], name: "index_api_v1_usage_charges_on_api_v1_plan_id"
  end

  add_foreign_key "api_v1_basic_charges", "api_v1_plans"
  add_foreign_key "api_v1_plans", "api_v1_companies"
  add_foreign_key "api_v1_usage_charges", "api_v1_plans"
end
