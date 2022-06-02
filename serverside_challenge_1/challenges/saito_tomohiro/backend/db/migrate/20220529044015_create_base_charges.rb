class CreateBaseCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :base_charges do |t|
      t.integer :ampere, null: false
      t.float :base_charge, null: false
      t.references :plan, foreign_key: true, null: false
      t.timestamps
    end
  end
end
