class CreateBasicRates < ActiveRecord::Migration[6.1]
  def change
    create_table :basic_rates do |t|
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
