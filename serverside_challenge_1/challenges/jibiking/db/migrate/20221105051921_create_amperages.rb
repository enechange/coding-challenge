class CreateAmperages < ActiveRecord::Migration[7.0]
  def change
    create_table :amperages do |t|
      t.integer :amperage, null: false
      t.integer :contract_unit, null: false
      t.float :amperage_price, null: false
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
