class CreateMeasuredRates < ActiveRecord::Migration[7.0]
  def change
    create_table :measured_rates do |t|
      t.integer :electricity_usage_min, limit: 2, null: false
      t.integer :electricity_usage_max, limit: 2, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.references :plan, null: false, type: :integer, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
