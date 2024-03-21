class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_charges do |t|
      t.belongs_to :plan, nul: false
      t.integer :ampere, null: false
      t.integer :unit, null: false
      t.decimal :price, null: false, scale: 2, precision: 6
      t.timestamps
    end
  end
end
