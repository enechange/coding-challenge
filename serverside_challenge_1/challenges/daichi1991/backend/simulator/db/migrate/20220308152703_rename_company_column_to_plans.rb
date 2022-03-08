class RenameCompanyColumnToPlans < ActiveRecord::Migration[6.0]
  def change
    rename_column :plans, :company, :provider_name
  end
end
