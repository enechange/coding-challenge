class CreateMeterRates < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_rates do |t|
      t.integer :min_usage, null: false
      t.integer :max_usage
      t.decimal :price, null: false, scale: 2, precision: 6
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
