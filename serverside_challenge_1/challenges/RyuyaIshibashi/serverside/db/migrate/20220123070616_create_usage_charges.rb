class CreateUsageCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :usage_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :from, null: false, precision:12, scale:2
      t.decimal :to, precision:12, scale:2
      t.decimal :unit_price, null: false, precision:12, scale:2

      t.timestamps
    end
    add_index :usage_charges, [:plan_id, :from, :to]
  end
end
