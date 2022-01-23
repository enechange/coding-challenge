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

ActiveRecord::Schema.define(version: 2022_01_23_070616) do

  create_table "basic_fees", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.decimal "ampare", precision: 10, null: false
    t.decimal "fee", precision: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ampare"], name: "index_basic_fees_on_ampare"
    t.index ["plan_id"], name: "index_basic_fees_on_plan_id"
  end

  create_table "companies", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "plans", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_plans_on_company_id"
  end

  create_table "usage_charges", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.decimal "from", precision: 10, null: false
    t.decimal "to", precision: 10
    t.decimal "unit_price", precision: 10, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id", "from", "to"], name: "index_usage_charges_on_plan_id_and_from_and_to"
    t.index ["plan_id"], name: "index_usage_charges_on_plan_id"
  end

  add_foreign_key "basic_fees", "plans"
  add_foreign_key "plans", "companies"
  add_foreign_key "usage_charges", "plans"
end
