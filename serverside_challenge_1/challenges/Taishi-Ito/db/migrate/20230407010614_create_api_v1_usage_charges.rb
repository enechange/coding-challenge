class CreateApiV1UsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :api_v1_usage_charges do |t|
      t.integer :from_khw
      t.integer :to_khw
      t.decimal :charge, precision: 10, scale: 2
      t.decimal :stacked_charge, precision: 10, scale: 2
      t.references :api_v1_plan, null: false, foreign_key: true
      t.timestamps
    end
  end
end
