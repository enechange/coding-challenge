class CreateKilowattos < ActiveRecord::Migration[7.0]
  def change
    create_table :kilowattos do |t|
      t.integer :min_kilowatto, null: false
      t.integer :max_kilowatto
      t.integer :kwh_unit, null: false
      t.float :kilowatto_price, null: false
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
