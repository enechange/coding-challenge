class CreateUsageCharges < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_charges do |t|

      t.timestamps
    end
  end
end
