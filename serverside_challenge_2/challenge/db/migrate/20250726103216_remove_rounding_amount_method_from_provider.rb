class RemoveRoundingAmountMethodFromProvider < ActiveRecord::Migration[7.0]
  def up
    remove_column :providers, :rounding_amount_method, :string
  end

  def down
    add_column :providers, :rounding_amount_method, :string
  end
end