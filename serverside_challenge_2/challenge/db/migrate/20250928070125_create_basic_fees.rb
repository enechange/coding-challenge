class CreateBasicFees < ActiveRecord::Migration[7.0]
  def change
    create_table :basic_fees, comment: '基本料金' do |t|
      t.string :code, null: false
      t.string :plan_code, null: false
      t.integer :ampere, null: false, comment: "契約アンペア数(A)"
      t.decimal :fee, precision: 10, scale: 2, null: false, comment: "基本料金(円)"
      t.timestamps
    end

    add_index :basic_fees, :code, unique: true
    add_index :basic_fees, [:plan_code, :ampere], unique: true
    add_index :basic_fees, :ampere
    add_foreign_key :basic_fees, :plans, column: :plan_code, primary_key: :code
  end
end
