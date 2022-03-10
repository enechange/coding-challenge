class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
