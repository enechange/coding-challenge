class CreateUnitPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :unit_prices do |t|
      t.integer :plan_id, null: false
      t.integer :lower_usage_limit, null: false
      t.integer :upper_usage_limit
      t.float :price, null: false

      t.timestamps
    end

    add_index :unit_prices, [:plan_id, :lower_usage_limit], unique: true
  end
end
