class CreateUsageRates < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_rates do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :min_kwh
      t.integer :max_kwh
      t.decimal :price_per_kwh

      t.timestamps
    end
  end
end
