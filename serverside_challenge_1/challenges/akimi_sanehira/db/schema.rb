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

ActiveRecord::Schema.define(version: 2022_06_24_024706) do

  create_table "basic_fees", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.decimal "ampere", precision: 2, null: false
    t.decimal "base_fee", precision: 12, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_basic_fees_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "provider_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "usage_charges", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.decimal "min_usage", precision: 12, scale: 2, null: false
    t.decimal "max_usage", precision: 12, scale: 2
    t.decimal "unit_usage_fee", precision: 12, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_usage_charges_on_plan_id"
  end

  add_foreign_key "basic_fees", "plans"
  add_foreign_key "plans", "providers"
  add_foreign_key "usage_charges", "plans"
end
