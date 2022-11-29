class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :provider_name, null: false

      t.timestamps
    end
  end
end
