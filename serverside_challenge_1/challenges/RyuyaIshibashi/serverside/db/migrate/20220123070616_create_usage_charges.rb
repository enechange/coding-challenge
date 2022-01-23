class CreateUsageCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :usage_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :from, null: false
      t.decimal :to
      t.decimal :unit_price, null: false

      t.timestamps
    end
    add_index :usage_charges, [:plan_id, :from, :to]
  end
end
