class CreateElectricityRatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :electricity_rate_plans do |t|
      t.string :name, null: false
      t.references :electric_power_provider,
                    null: false,
                    foreign_key: true,
                    index: false
      t.timestamps
    end

    add_index :electricity_rate_plans,
              [:name, :electric_power_provider_id],
              unique: true,
              name: 'name_and_provider_id'
  end
end
