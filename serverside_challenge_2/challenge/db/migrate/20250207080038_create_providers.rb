class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers do |t|
      t.string :name, null: false
      t.string :provider_type, null: false
      t.integer :state, default: 1, null: false

      t.timestamps
    end

    add_index :providers, :provider_type, unique: true
  end
end
