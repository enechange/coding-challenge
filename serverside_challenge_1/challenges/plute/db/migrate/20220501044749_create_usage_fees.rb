class CreateUsageFees < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_fees do |t|
      t.integer :plan_id, null: false
      t.integer :min_usage, null: false
      t.integer :max_usage, null: false
      t.float :unit_usage_fee, null: false
      t.timestamps
    end
  end
end
