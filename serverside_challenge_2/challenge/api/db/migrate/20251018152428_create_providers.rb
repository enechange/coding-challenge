class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.timestamps
    end

    add_index :providers, :code, unique: true
  end
end
