class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.string :name, :null => false

      t.timestamps
    end
  end
end
