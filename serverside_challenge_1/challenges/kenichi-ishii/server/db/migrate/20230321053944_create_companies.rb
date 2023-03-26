class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: false, force: true do |t|
      t.integer :id, null: false
      t.string  :provider_name, null: false
      t.string  :plan_name, null: false
      t.timestamps
    end
    add_index :companies, [:id], unique: true
  end
end
