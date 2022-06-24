class CreateUsageCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :usage_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :min_usage, null: false, precision: 12, scale: 2
      t.decimal :max_usage, precision: 12, scale: 2
      t.decimal :unit_usage_fee, null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
