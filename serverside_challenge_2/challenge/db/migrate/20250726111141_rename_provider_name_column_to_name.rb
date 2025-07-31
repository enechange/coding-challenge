class RenameProviderNameColumnToName < ActiveRecord::Migration[7.0]
  def change
    rename_column :providers, :provider_name, :name
  end
end
