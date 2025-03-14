# frozen_string_literal: true

class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers, comment: '電力会社を格納する' do |t|
      t.string :name, null: false, comment: '会社名'

      t.timestamps
    end

    add_index :providers, :name, unique: true
  end
end
