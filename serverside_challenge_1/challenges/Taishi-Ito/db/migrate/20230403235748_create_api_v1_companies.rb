class CreateApiV1Companies < ActiveRecord::Migration[7.0]
  def change
    create_table :api_v1_companies do |t|
      t.string :name
      t.timestamps
    end
  end
end
