class ChangeColumnNullToBasicCharges < ActiveRecord::Migration[6.0]
  def change
    change_column_null :basic_charges, :plan_id, false
    change_column_null :basic_charges, :ampere, false
    change_column_null :basic_charges, :charge, false
  end
end
