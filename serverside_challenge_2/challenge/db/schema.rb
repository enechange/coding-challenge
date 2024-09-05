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

ActiveRecord::Schema[7.0].define(version: 2024_09_05_142210) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_monthly_fees", force: :cascade do |t|
    t.integer "contract_amperage", default: 0, null: false, comment: "契約アンペア数"
    t.money "price", scale: 2, default: "0.0", null: false, comment: "基本料金(円)"
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_basic_monthly_fees_on_plan_id"
  end

  create_table "electricity_usages", force: :cascade do |t|
    t.integer "from", default: 0, null: false, comment: "電気使用量(開始値)"
    t.integer "to", default: 0, comment: "電気使用量時(終了値)"
    t.money "unit_price", scale: 2, default: "0.0", null: false, comment: "従量料金単価(円/kWh)"
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_electricity_usages_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false, comment: "プラン名"
    t.bigint "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "usage_tier", default: false, comment: "段階料金が導入されているのかを保持する"
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name", null: false, comment: "会社名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "basic_monthly_fees", "plans"
  add_foreign_key "electricity_usages", "plans"
  add_foreign_key "plans", "providers"
end
