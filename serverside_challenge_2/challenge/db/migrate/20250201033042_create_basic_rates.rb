class CreateBasicRates < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_rates do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :ampere
      t.decimal :price

      t.timestamps
    end
  end
end
