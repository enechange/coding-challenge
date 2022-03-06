class CreateBasicCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :basic_charges do |t|
      t.references :plan, foreign_key: true
      t.integer :ampere
      t.decimal :charge, precision: 10, scale: 2
      t.timestamps
    end
  end
end
