class ChangeColumnNullToCommodityCharges < ActiveRecord::Migration[6.0]
  def change
    change_column_null :commodity_charges, :plan_id, false
    change_column_null :commodity_charges, :min_amount, false
    change_column_null :commodity_charges, :max_amount, false
  end
end
