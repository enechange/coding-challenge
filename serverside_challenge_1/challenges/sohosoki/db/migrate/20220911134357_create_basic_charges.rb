class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_charges do |t|
      t.integer :ampere, null: false
      t.decimal :price, precision: 7, scale: 2
      t.references :plan, null: false

      t.timestamps
    end
  end
end
