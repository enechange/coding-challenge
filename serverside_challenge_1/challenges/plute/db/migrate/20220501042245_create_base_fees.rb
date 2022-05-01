class CreateBaseFees < ActiveRecord::Migration[7.0]
  def change
    create_table :base_fees do |t|
      t.integer :plan_id, null: false
      t.integer :ampere, null: false
      t.float :base_fee, null: false
      t.timestamps
    end
  end
end
