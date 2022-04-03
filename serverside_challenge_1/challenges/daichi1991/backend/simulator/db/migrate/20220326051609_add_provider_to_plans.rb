class AddProviderToPlans < ActiveRecord::Migration[6.0]
  def change
    add_reference :plans, :provider, null: false, foreign_key: true, after: :id
  end
end
