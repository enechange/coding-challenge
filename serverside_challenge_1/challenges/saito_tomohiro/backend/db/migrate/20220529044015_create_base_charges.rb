class CreateBaseCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :base_charges do |t|
      t.integer :ampere, null: false
<<<<<<< HEAD
      t.float :base_charge, null: false
=======
      t.decimal :base_charge, null: false, scale: 2, precision: 6
>>>>>>> f92b10e... add all
      t.references :plan, foreign_key: true, null: false
      t.timestamps
    end
  end
end
