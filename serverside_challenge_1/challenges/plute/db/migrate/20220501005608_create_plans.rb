class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.integer :provider_id, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
