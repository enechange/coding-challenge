class AddUsageTierToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :usage_tier, :boolean, default: false, comment: '段階料金が導入されているのかを保持する'
  end
end
