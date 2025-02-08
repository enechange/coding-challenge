# frozen_string_literal: true

class CreateElectricityPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_plans do |t|
      t.string :name, null: false
      t.references :electricity_provider, null: false, foreign_key: true

      t.timestamps
    end
  end
end
