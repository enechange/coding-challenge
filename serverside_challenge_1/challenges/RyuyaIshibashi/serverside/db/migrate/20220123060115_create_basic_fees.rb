class CreateBasicFees < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_fees do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :ampare, null: false, precision:12, scale:2
      t.decimal :fee, null: false, precision:12, scale:2

      t.timestamps
    end
    add_index :basic_fees, :ampare
  end
end
