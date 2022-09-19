class CreatePayAsYouGoFees < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_as_you_go_fees do |t|
      t.integer :min_usage
      t.integer :max_usage
      t.decimal :price, precision: 6, scale: 2
      t.references :plan, null: false

      t.timestamps
    end
  end
end
