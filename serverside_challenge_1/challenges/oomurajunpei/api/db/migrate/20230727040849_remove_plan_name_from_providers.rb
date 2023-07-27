class RemovePlanNameFromProviders < ActiveRecord::Migration[7.0]
  def up
    remove_column :providers, :plan_name
  end

  def down
    add_column :providers, :plan_name, :string, null: false
  end
end
