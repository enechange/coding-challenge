class CreateApiV1Plans < ActiveRecord::Migration[7.0]
  def change
    create_table :api_v1_plans do |t|
      t.references :api_v1_company, null: false, foreign_key: true
      t.string :name
      t.timestamps
    end
  end
end
