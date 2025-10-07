class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans, comment: 'プラン' do |t|
      t.string :code, null: false
      t.string :provider_code, null: false
      t.string :name, null: false
      t.timestamps
    end

    add_index :plans, :code, unique: true
    add_index :plans, :provider_code
    add_foreign_key :plans, :providers, column: :provider_code, primary_key: :code
  end
end
