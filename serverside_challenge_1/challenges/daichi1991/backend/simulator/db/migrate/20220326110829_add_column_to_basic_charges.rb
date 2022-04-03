class AddColumnToBasicCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :basic_charges, :plan_code, :string, null: false, after: :id
  end
end
