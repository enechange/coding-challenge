class CreateElectricityFees < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_fees do |t|
      t.belongs_to :plan, nul: false
      t.integer :classification_min, null: false
      t.integer :classification_max
      t.integer :unit, null: false
      t.decimal :price, null: false, scale: 2, precision: 6
      t.timestamps
    end
  end
end
