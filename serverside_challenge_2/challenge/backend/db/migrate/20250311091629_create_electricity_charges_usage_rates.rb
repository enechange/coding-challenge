# frozen_string_literal: true

class CreateElectricityChargesUsageRates < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_charges_usage_rates, comment: 'プラン毎の電気従量料金を格納する' do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :min_usage, null: false, comment: '電気使用量(kWh)の下限値(境界値を含まない)'
      t.integer :max_usage, comment: '電気使用量(kWh)の上限値(境界値を含む)'
      t.decimal :unit_rate, precision: 10, scale: 2, null: false, comment: '従量料金単価(円/kWh)'

      t.timestamps
    end
  end
end
