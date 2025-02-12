class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.references :provider, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.string :plan_type, null: false
      t.integer :state, default: 1, null: false

      t.timestamps
    end

    add_index :plans, [ :provider_id, :plan_type ], unique: true
  end
end
