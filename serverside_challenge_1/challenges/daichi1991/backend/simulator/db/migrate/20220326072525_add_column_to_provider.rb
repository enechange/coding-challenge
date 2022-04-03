class AddColumnToProvider < ActiveRecord::Migration[6.0]
  def change
    remove_column :providers, :id
    add_column :providers, :provider_code, :string, primary_key: true, first: true
  end
end
