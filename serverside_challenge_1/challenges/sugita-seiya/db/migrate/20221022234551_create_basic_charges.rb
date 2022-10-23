class CreateBasicCharges < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_charges do |t|
      t.integer :contract_amperage, null: false
      t.float :charge_unit_price, null: false
      t.references :electricity_rate_plan,
                    null: false,
                    foreign_key: true,
                    index: false
      t.timestamps
    end
    add_index :basic_charges,
              [:electricity_rate_plan_id, :contract_amperage],
              unique: true,
              name: 'plan_id_and_contract_amperage'
  end
end
