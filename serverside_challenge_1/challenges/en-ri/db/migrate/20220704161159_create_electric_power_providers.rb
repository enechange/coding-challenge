class CreateElectricPowerProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :electric_power_providers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
