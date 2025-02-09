# frozen_string_literal: true

class CreateElectricityProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_providers do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
