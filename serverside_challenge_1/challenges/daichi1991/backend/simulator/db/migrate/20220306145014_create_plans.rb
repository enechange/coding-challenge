class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :provider_name
      t.string :plan
      t.timestamps
    end
  end
end
