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

ActiveRecord::Schema[7.0].define(version: 2025_09_28_070132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_fees", comment: "基本料金", force: :cascade do |t|
    t.string "code", null: false
    t.string "plan_code", null: false
    t.integer "ampere", null: false, comment: "契約アンペア数(A)"
    t.decimal "fee", precision: 10, scale: 2, null: false, comment: "基本料金(円)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ampere"], name: "index_basic_fees_on_ampere"
    t.index ["code"], name: "index_basic_fees_on_code", unique: true
    t.index ["plan_code", "ampere"], name: "index_basic_fees_on_plan_code_and_ampere", unique: true
  end

  create_table "plans", comment: "プラン", force: :cascade do |t|
    t.string "code", null: false
    t.string "provider_code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_plans_on_code", unique: true
    t.index ["provider_code"], name: "index_plans_on_provider_code"
  end

  create_table "providers", comment: "電力会社", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_providers_on_code", unique: true
  end

  create_table "usage_charges", comment: "従量料金", force: :cascade do |t|
    t.string "code", null: false
    t.string "plan_code", null: false
    t.integer "usage_lower", null: false, comment: "電気使用量(kWh) 下限"
    t.integer "usage_upper", comment: "電気使用量(kWh) 上限"
    t.decimal "unit_price", precision: 10, scale: 2, null: false, comment: "従量料金単価(円/kWh)"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_usage_charges_on_code", unique: true
    t.index ["plan_code", "usage_lower", "usage_upper"], name: "index_usage_charges_on_plan_code_and_usage_range"
    t.index ["usage_lower", "usage_upper"], name: "index_usage_charges_on_usage_lower_and_usage_upper"
  end

  add_foreign_key "basic_fees", "plans", column: "plan_code", primary_key: "code"
  add_foreign_key "plans", "providers", column: "provider_code", primary_key: "code"
  add_foreign_key "usage_charges", "plans", column: "plan_code", primary_key: "code"
end
