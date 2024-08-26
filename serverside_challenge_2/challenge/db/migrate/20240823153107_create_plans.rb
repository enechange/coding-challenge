# frozen_string_literal: true

class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false, comment: 'プラン名'

      t.references :provider, null: false, foreign_key: true
      t.timestamps
    end
  end
end
