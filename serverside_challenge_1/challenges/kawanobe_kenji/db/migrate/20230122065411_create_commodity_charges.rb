class CreateCommodityCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :commodity_charges do |t|
      t.references :plan, null: false, foreign_key: true
      t.integer :kwh_from, null: false
      t.integer :kwh_to
      # precision:12, scale:2 => 全体１２桁（整数部10桁,少数部2桁）
      t.decimal :charge, null: false, precision:12, scale:2
      t.timestamps
    end
  end
end
