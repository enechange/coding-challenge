class CreateBasicFees < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_fees do |t|
      t.references :plan, null: false, foreign_key: true
      t.decimal :ampere, null: false, precision: 2
      t.decimal :base_fee, null: false, precision: 12, scale: 2

      t.timestamps
    end
  end
end
