class CreateUsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_charges do |t|
      t.references :plan, null: false, foreign_key: { on_delete: :cascade }
      t.integer :lower_limit, null: false
      t.integer :upper_limit
      t.decimal :charge, precision: 10, scale: 2, null: false
      t.integer :state, default: 1, null: false


      t.timestamps
    end
  end
end
