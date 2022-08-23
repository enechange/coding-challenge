class CreateElectricPowerCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :electric_power_companies do |t|

      t.timestamps
    end
  end
end
