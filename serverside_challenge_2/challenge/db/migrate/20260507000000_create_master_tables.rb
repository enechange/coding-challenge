# frozen_string_literal: true

class CreateMasterTables < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.timestamps

      t.index :name, unique: true
    end

    create_table :plans do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps

      t.index %i[provider_id name], unique: true
      t.index :slug, unique: true
    end

    create_table :ampere_based_rates do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :ampere, null: false
      t.decimal :rate, precision: 10, scale: 2, null: false
      t.timestamps

      t.index %i[plan_id ampere], unique: true
      t.check_constraint 'rate >= 0', name: 'ampere_based_rates_rate_non_negative'
      t.check_constraint 'ampere IN (10, 15, 20, 30, 40, 50, 60)', name: 'ampere_based_rates_ampere_allowed'
    end

    create_table :usage_based_rates do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :kilowatt_hour_low, null: false
      t.integer :kilowatt_hour_high, null: false
      t.decimal :rate, precision: 10, scale: 2, null: false
      t.timestamps

      t.index %i[plan_id kilowatt_hour_low kilowatt_hour_high], unique: true,
                                                                name: 'index_usage_based_rates_on_plan_and_range'
      t.check_constraint 'rate >= 0', name: 'usage_based_rates_rate_non_negative'
      t.check_constraint 'kilowatt_hour_low > 0', name: 'usage_based_rates_low_positive'
      t.check_constraint 'kilowatt_hour_low <= kilowatt_hour_high', name: 'usage_based_rates_low_le_high'
    end
  end
end
