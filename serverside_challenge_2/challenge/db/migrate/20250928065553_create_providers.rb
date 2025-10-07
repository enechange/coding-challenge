class CreateProviders < ActiveRecord::Migration[7.0]
  def change
    create_table :providers, comment: '電力会社' do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :providers, :code, unique: true
  end
end
