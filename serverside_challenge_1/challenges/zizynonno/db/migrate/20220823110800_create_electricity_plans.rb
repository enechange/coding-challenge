class CreateElectricityPlans < ActiveRecord::Migration[6.1]
  def change
    create_table :electricity_plans do |t|
      t.string :name, null: false
      t.references :electric_power_company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
