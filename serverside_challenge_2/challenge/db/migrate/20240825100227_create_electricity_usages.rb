# frozen_string_literal: true

class CreateElectricityUsages < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_usages do |t|
      t.integer :from, null: false, default: 0, comment: '電気使用量(開始値)'
      t.integer :to, default: 0, comment: '電気使用量時(終了値)'
      # NOTE: money 型という型が追加されたようなので、使ってみる https://tech.actindi.net/2019/11/15/154609
      t.money :unit_price, null: false, default: 0, scale: 2, comment: '従量料金単価(円/kWh)'

      t.references :plan, null: false, foreign_key: true
      t.timestamps
    end
  end
end
