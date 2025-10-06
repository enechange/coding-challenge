class CreateEnergyPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :energy_plans do |t|
      t.string :provider_name, null: false
      t.string :plan_name, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end
  end
end