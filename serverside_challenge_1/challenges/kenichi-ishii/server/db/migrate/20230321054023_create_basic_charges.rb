class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_charges, force: true do |t|
      t.integer :ampere, null: false
      t.decimal :fee, null: false
      t.references :company, foreign_key: true,null: false
      t.timestamps
    end
  end
end
