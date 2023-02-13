class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.references :provider, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
