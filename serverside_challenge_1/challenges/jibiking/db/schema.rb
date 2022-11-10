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

ActiveRecord::Schema[7.0].define(version: 2022_11_05_071158) do
  create_table "amperages", charset: "utf8mb3", force: :cascade do |t|
    t.integer "amperage", null: false
    t.integer "unit", null: false
    t.float "amperage_price", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_amperages_on_plan_id"
  end

  create_table "kilowattos", charset: "utf8mb3", force: :cascade do |t|
    t.integer "min_kilowatto", null: false
    t.integer "max_kilowatto"
    t.integer "unit", null: false
    t.float "kilowatto_price", null: false
    t.bigint "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_kilowattos_on_plan_id"
  end

  create_table "plans", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "provider_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_id"], name: "index_plans_on_provider_id"
  end

  create_table "providers", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "amperages", "plans"
  add_foreign_key "kilowattos", "plans"
  add_foreign_key "plans", "providers"
end
