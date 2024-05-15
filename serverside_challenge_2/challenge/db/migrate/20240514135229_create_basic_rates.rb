class CreateBasicRates < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_rates do |t|
      t.references :electricity_plan, null: false, foreign_key: true
      t.integer :amperage
      t.decimal :rate, precision: 6, scale: 2
      t.timestamps
    end
  end
end
