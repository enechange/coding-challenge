class RemoveColumnFromPlans < ActiveRecord::Migration[6.0]
  def change
    remove_column :plans, :provider_id
  end
end
