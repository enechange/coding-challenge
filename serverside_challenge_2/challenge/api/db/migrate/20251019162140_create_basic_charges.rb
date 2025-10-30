class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :ampere, null: false
      t.decimal :amount, null: false, precision: 8, scale: 2
      t.timestamps
    end

    add_index :basic_charges, [:plan_id, :ampere], unique: true
  end
end
