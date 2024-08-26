# frozen_string_literal: true

class CreateBasicMonthlyFees < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_monthly_fees do |t|
      t.integer :contract_amperage, null: false, default: 0, comment: '契約アンペア数'
      # NOTE: https://tech.actindi.net/2019/11/15/154609
      t.money :price, null: false, scale: 2, default: 0.0, comment: '基本料金(円)'

      t.references :plan, null: false, foreign_key: true
      t.timestamps
    end
  end
end
