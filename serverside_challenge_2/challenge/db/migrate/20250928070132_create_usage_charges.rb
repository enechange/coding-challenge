class CreateUsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_charges, comment: '従量料金' do |t|
      t.string :code, null: false
      t.string :plan_code, null: false
      t.integer :usage_lower, null: false, comment: "電気使用量(kWh) 下限"
      t.integer :usage_upper, comment: "電気使用量(kWh) 上限"
      t.decimal :unit_price, precision: 10, scale: 2, null: false, comment: "従量料金単価(円/kWh)"
      t.timestamps
    end

    add_index :usage_charges, :code, unique: true
    add_index :usage_charges, [:usage_lower, :usage_upper]
    add_index :usage_charges, [:plan_code, :usage_lower, :usage_upper], name: 'index_usage_charges_on_plan_code_and_usage_range'
    add_foreign_key :usage_charges, :plans, column: :plan_code, primary_key: :code
  end
end
