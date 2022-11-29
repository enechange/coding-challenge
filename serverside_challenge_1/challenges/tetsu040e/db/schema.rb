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

ActiveRecord::Schema[7.0].define(version: 2022_11_28_084428) do
  create_table "basic_prices", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "ampere", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "ampere"], name: "index_basic_prices_on_plan_id_and_ampere", unique: true
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_prices", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "lower_usage_limit", null: false
    t.integer "upper_usage_limit"
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "lower_usage_limit"], name: "index_unit_prices_on_plan_id_and_lower_usage_limit", unique: true
  end

end
