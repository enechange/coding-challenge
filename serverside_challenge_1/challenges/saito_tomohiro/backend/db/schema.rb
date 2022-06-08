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

ActiveRecord::Schema[7.0].define(version: 20_220_529_091_905) do
  create_table 'base_charges', force: :cascade do |t|
    t.integer 'ampere', null: false
    t.decimal 'base_charge', precision: 6, scale: 2, null: false
    t.integer 'plan_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['plan_id'], name: 'index_base_charges_on_plan_id'
  end

  create_table 'per_use_charges', force: :cascade do |t|
    t.integer 'min_usage', null: false
    t.integer 'max_usage'
    t.decimal 'per_use_charge', precision: 6, scale: 2, null: false
    t.integer 'plan_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['plan_id'], name: 'index_per_use_charges_on_plan_id'
  end

  create_table 'plans', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'provider_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['provider_id'], name: 'index_plans_on_provider_id'
  end

  create_table 'providers', force: :cascade do |t|
    t.string 'name', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'base_charges', 'plans'
  add_foreign_key 'per_use_charges', 'plans'
  add_foreign_key 'plans', 'providers'
end
