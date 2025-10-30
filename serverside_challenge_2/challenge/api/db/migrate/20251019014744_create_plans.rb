class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps
    end

    add_index :plans, [:provider_id, :code], unique: true
  end
end
