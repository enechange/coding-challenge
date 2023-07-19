class ChangeDataUnitPriceToPayPerUseRate < ActiveRecord::Migration[7.0]
  def change
    change_column :pay_per_use_rates, :unit_price, :float
  end
end
