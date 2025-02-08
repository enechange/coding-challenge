# frozen_string_literal: true

class CreateElectricityPlanBasicFees < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_plan_basic_fees do |t|
      t.integer :ampere, null: false
      t.decimal :fee, null: false
      t.references :electricity_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
