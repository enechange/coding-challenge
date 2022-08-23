class CreateMeterRates < ActiveRecord::Migration[6.1]
  def change
    create_table :meter_rates do |t|
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
