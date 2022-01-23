class CreateBasicFees < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_fees do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :ampare, null: false
      t.decimal :fee, null: false

      t.timestamps
    end
    add_index :basic_fees, [:plan_id, :ampare]
  end
end
