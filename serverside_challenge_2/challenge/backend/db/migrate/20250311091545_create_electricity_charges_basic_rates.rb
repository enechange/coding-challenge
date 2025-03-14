# frozen_string_literal: true

class CreateElectricityChargesBasicRates < ActiveRecord::Migration[7.0]
  def change
    create_table :electricity_charges_basic_rates, comment: 'プラン毎の電気基本料金を格納する' do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :ampere, null: false, comment: '契約アンペア数(A)'
      t.decimal :basic_rate, precision: 10, scale: 2, null: false, comment: '基本料金(円)'

      t.timestamps
    end

    add_index :electricity_charges_basic_rates, %i[plan_id ampere], unique: true
  end
end
