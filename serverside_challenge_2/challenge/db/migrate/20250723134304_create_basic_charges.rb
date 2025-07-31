class CreateBasicCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :provider_name, :null => false
      t.string :rounding_amount_method, :null => false

      t.timestamps
    end

    create_table :power_supply_plans do |t|
      t.belongs_to :provider
      t.string :plan_name, :null => false

      t.timestamps
    end
    
    create_table :meter_rate_charges do |t|
      t.belongs_to :power_supply_plan
      t.integer :min_meter_rate, :null => false
      t.integer :max_meter_rate
      t.decimal :price, precision: 6, scale: 2, :null => false

      t.timestamps
    end

    create_table :basic_charges do |t|
      t.belongs_to :power_supply_plan 
      t.integer :amp, :null => false
      t.decimal :price, precision: 6, scale: 2, :null => false

      t.timestamps
    end
  end
end
