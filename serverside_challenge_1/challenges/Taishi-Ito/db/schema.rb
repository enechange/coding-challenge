ActiveRecord::Schema[7.0].define(version: 2023_04_07_005748) do
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

  add_foreign_key "api_v1_basic_charges", "api_v1_plans"
  add_foreign_key "api_v1_plans", "api_v1_companies"
end
