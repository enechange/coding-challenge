class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :plan_name, null: false

      t.timestamps
    end
  end
end
