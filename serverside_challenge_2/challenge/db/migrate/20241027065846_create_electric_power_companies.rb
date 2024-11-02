class CreateElectricPowerCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :electric_power_companies do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :electric_power_companies, [ :name ], unique: true
  end
end
