class CreatePerUseCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :per_use_charges do |t|
      t.integer :min_usage, null: false
      t.integer :max_usage, null: false
      t.float :per_use_charge, null: false
      t.references :plan, foreign_key: true, null: false
      t.timestamps
    end
  end
end
