class CreateElectricityUsages < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_usages do |t|
      t.integer :from, null: false, default: 0, comment: '電気使用量(開始値)'
      t.integer :to, default: 0, comment: '電気使用量時(終了値)'
      t.integer :unit_price, null: false, default: 0, comment: '従量料金単価(円/kWh)'

      t.references :provider, null: false, foreign_key: true
      t.timestamps
    end
  end
end
