# frozen_string_literal: true

class CreateElectricityPlanUsageFees < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_plan_usage_fees do |t|
      t.integer :min_usage, null: false
      t.decimal :fee, null: false
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
