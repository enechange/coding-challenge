class CreatePerUseCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :per_use_charges do |t|
      t.integer :min_usage, null: false
      t.integer :max_usage, null: false
      t.decimal :per_use_charge, null: false, scale: 2, precision: 6
      t.references :plan, foreign_key: true, null: false
      t.timestamps
    end
  end
end
