class RemoveColumnFromBasicCharges < ActiveRecord::Migration[6.0]
  def change
    remove_column :basic_charges, :plan_id
  end
end
