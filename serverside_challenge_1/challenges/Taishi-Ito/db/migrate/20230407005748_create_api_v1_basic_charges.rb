class CreateApiV1BasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :api_v1_basic_charges do |t|
      t.integer :ampere
      t.decimal :charge, precision: 10, scale: 2
      t.references :api_v1_plan, null: false, foreign_key: true
      t.timestamps
    end
  end
end
