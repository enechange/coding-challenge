class AddColumnToCommodityCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :commodity_charges, :plan_code, :string, after: :id
  end
end
