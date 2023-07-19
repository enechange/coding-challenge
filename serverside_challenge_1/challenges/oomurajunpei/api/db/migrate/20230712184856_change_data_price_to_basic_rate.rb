class ChangeDataPriceToBasicRate < ActiveRecord::Migration[7.0]
  def change
    change_column :basic_rates, :price, :float
  end
end
