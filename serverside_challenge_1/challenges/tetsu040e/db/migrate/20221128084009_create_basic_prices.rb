class CreateBasicPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_prices do |t|
      t.integer :plan_id, null: false
      t.integer :ampere, null: false
      t.float :price, null: false

      t.timestamps
    end

    add_index :basic_prices, [:plan_id, :ampere], unique: true
  end
end
