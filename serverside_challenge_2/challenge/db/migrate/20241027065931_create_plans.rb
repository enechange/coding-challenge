class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.references :electric_power_company, null: false, type: :integer, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
    add_index :plans, [ :electric_power_company_id, :name ], unique: true
  end
end
