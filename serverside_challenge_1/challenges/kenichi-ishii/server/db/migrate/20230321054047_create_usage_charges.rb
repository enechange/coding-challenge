class CreateUsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_charges, force: true do |t|
      t.integer :prev_tier, null: false
      t.integer :tier, null: false
      t.decimal :fee, null: false
      t.references :company,foreign_key: true, null: false
      t.timestamps
    end
  end
end
