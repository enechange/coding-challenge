class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_charges do |t|
      t.references :plan, null: false, foreign_key: { on_delete: :cascade }
      t.integer :ampere, null: false
      t.decimal :charge, precision: 10, scale: 2, null: false
      t.integer :state, default: 1, null: false

      t.timestamps
    end
  end
end
