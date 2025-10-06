class CreateUnitFees < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_fees do |t|
      t.references :energy_plan, null: false, foreign_key: true
      t.float :min_kwh, null: false
      t.float :max_kwh
      t.float :price, null: false

      t.timestamps
    end
  end
end
