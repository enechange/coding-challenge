class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.references :provider, null: false, type: :integer, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
    add_index :plans, [ :provider_id, :name ], unique: true
  end
end
