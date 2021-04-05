class CreateEnergyHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :energy_histories do |t|
      t.references :house_user
      t.integer :label
      t.integer :year
      t.integer :month
      t.float :temperature
      t.float :daylight
      t.integer :energy_production

      t.timestamps
    end
  end
end
