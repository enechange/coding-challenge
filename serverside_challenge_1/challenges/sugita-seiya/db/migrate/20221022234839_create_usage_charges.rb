class CreateUsageCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :usage_charges do |t|
      t.float :charge_unit_price, null: false
      t.integer :minimum_usage, null: false
      t.integer :max_usage
      t.references :electricity_rate_plan,
                    null: false,
                    foreign_key: true,
                    index: false
      t.timestamps
    end
    add_index :usage_charges,
              [:minimum_usage, :max_usage, :electricity_rate_plan_id],
              unique: true,
              name: 'minimum_and_max_and_plan_id'
  end
end
