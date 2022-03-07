class CreateCommodityCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :commodity_charges do |t|
      t.references :plan, foreign_key: true
      t.integer :min_amount
      t.integer :max_amount
      t.decimal :unit_price, precision: 10, scale: 2
      t.timestamps
    end
  end
end
