class CreatePayPerUseRates < ActiveRecord::Migration[7.0]
  def change
    create_table :pay_per_use_rates do |t|
      t.references :provider, null: false, foreign_key: true
      t.integer :unit_price, null: false
      t.integer :min_electricity_usage
      t.integer :max_electricity_usage

      t.timestamps
    end
  end
end
