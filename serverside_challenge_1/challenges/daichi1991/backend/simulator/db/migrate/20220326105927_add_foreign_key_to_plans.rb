class AddForeignKeyToPlans < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :plans, :providers, column: :provider_code, primary_key: :provider_code
  end
end
