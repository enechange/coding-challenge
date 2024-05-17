class CreateElectricityPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_plans do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
