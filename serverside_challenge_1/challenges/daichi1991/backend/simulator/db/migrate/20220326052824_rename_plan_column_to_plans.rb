class RenamePlanColumnToPlans < ActiveRecord::Migration[6.0]
  def change
    rename_column :plans, :plan, :plan_name
  end
end
