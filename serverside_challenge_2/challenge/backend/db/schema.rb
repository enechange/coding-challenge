# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_250_311_091_629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'electricity_charges_basic_rates', comment: 'プラン毎の電気基本料金を格納する', force: :cascade do |t|
    t.bigint 'plan_id', null: false
    t.integer 'ampere', null: false, comment: '契約アンペア数(A)'
    t.decimal 'basic_rate', precision: 10, scale: 2, null: false, comment: '基本料金(円)'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[plan_id ampere], name: 'index_electricity_charges_basic_rates_on_plan_id_and_ampere', unique: true
    t.index ['plan_id'], name: 'index_electricity_charges_basic_rates_on_plan_id'
  end

  create_table 'electricity_charges_usage_rates', comment: 'プラン毎の電気従量料金を格納する', force: :cascade do |t|
    t.bigint 'plan_id', null: false
    t.integer 'min_usage', null: false, comment: '電気使用量(kWh)の下限値(境界値を含まない)'
    t.integer 'max_usage', comment: '電気使用量(kWh)の上限値(境界値を含む)'
    t.decimal 'unit_rate', precision: 10, scale: 2, null: false, comment: '従量料金単価(円/kWh)'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['plan_id'], name: 'index_electricity_charges_usage_rates_on_plan_id'
  end

  create_table 'plans', comment: '各電力会社毎のプランを格納する', force: :cascade do |t|
    t.bigint 'provider_id', null: false
    t.string 'name', null: false, comment: 'プラン名'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[provider_id name], name: 'index_plans_on_provider_id_and_name', unique: true
    t.index ['provider_id'], name: 'index_plans_on_provider_id'
  end

  create_table 'providers', comment: '電力会社を格納する', force: :cascade do |t|
    t.string 'name', null: false, comment: '会社名'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_providers_on_name', unique: true
  end

  add_foreign_key 'electricity_charges_basic_rates', 'plans'
  add_foreign_key 'electricity_charges_usage_rates', 'plans'
  add_foreign_key 'plans', 'providers'
end
