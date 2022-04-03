class ChangeColumnNullToPlans < ActiveRecord::Migration[6.0]
  def change
    change_column_null :plans, :plan_name, false
  end
end
