class RenamePlanNameColumnToName < ActiveRecord::Migration[7.0]
  def change
        rename_column :power_supply_plans, :plan_name, :name
  end
end
