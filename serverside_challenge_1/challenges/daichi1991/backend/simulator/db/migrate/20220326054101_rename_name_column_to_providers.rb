class RenameNameColumnToProviders < ActiveRecord::Migration[6.0]
  def change
    rename_column :providers, :name, :provider_name
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
