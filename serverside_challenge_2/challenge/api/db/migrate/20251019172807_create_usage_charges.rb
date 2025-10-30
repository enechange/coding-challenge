class CreateUsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :from_kwh, null: false
      t.integer :to_kwh
      t.decimal :unit_price, null: false, precision: 8, scale: 2
      t.timestamps
    end

    add_index :usage_charges, [:plan_id, :from_kwh], unique: true
  end
end
