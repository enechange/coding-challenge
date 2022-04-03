class AddColumnToPlans2 < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :provider_code, :string, null: false, after: :plan_name
  end
end
