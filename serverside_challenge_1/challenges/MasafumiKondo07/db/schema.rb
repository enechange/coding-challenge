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

ActiveRecord::Schema[7.0].define(version: 2022_09_15_122849) do
  create_table "basic_charges", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "plan_id"
    t.integer "ampere", null: false
    t.integer "unit", null: false
    t.decimal "price", precision: 6, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_basic_charges_on_plan_id"
  end

  create_table "companies", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "electricity_fees", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "plan_id"
    t.integer "classification_min", null: false
    t.integer "classification_max"
    t.integer "unit", null: false
    t.decimal "price", precision: 6, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_electricity_fees_on_plan_id"
  end

  create_table "plans", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_plans_on_company_id"
  end

end
