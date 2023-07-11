class CreateBasicRates < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_rates do |t|
      t.references :provider, null: false, foreign_key: true
      t.integer :ampere, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
