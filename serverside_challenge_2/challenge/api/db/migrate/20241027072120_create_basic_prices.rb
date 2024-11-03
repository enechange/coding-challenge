class CreateBasicPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_prices do |t|
      t.integer :amperage, limit: 2, null: false
      t.decimal :price, precision: 7, scale: 2, null: false
      t.references :plan, null: false, type: :integer, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
    add_index :basic_prices, [ :plan_id, :amperage ], unique: true
  end
end
