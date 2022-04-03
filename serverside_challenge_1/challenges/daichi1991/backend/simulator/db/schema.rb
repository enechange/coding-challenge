# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_26_111547) do

  create_table "basic_charges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_ja_0900_as_cs", force: :cascade do |t|
    t.string "plan_code", null: false
    t.integer "ampere", null: false
    t.decimal "charge", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_code"], name: "fk_rails_36cbfc5eba"
  end

  create_table "commodity_charges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_ja_0900_as_cs", force: :cascade do |t|
    t.string "plan_code"
    t.integer "min_amount", null: false
    t.integer "max_amount", null: false
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_code"], name: "fk_rails_4e4793210c"
  end

  create_table "plans", primary_key: "plan_code", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_ja_0900_as_cs", force: :cascade do |t|
    t.string "plan_name", null: false
    t.string "provider_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_code"], name: "fk_rails_f84095dcf1"
  end

  create_table "providers", primary_key: "provider_code", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_ja_0900_as_cs", force: :cascade do |t|
    t.string "provider_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "basic_charges", "plans", column: "plan_code", primary_key: "plan_code"
  add_foreign_key "commodity_charges", "plans", column: "plan_code", primary_key: "plan_code"
  add_foreign_key "plans", "providers", column: "provider_code", primary_key: "provider_code"
end
