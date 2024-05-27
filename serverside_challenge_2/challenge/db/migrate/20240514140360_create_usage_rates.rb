class CreateUsageRates < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_rates do |t|
      t.references :electricity_plan, null: false, foreign_key: true
      t.integer :limit_kwh
      t.decimal :rate, precision: 4, scale: 2, null: false
      t.timestamps
    end
  end
end
