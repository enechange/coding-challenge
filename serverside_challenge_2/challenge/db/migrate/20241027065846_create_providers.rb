class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :providers, [ :name ], unique: true
  end
end
