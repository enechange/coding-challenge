class CreateBasicFees < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_fees do |t|
      t.references :energy_plan, null: false, foreign_key: true
      t.integer :ampere, null: false
      t.float :price, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end
