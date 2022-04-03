class AddColumnToPlans < ActiveRecord::Migration[6.0]
  def change
    remove_column :plans, :id
    add_column :plans, :plan_code, :string, primary_key: true, first: true
  end
end
