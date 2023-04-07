ActiveRecord::Schema[7.0].define(version: 2023_04_03_235748) do
  create_table "api_v1_companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
