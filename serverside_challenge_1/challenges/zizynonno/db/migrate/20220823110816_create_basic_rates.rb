class CreateBasicRates < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_rates do |t|
      t.integer :ampere, null: false
      t.decimal :price, null: false, scale: 2, precision: 6
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
