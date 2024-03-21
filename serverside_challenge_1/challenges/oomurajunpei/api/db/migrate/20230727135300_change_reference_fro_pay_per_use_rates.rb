class ChangeReferenceFroPayPerUseRates < ActiveRecord::Migration[7.0]
  def up
    add_reference :pay_per_use_rates, :plan, foreign_key: true
    remove_foreign_key :pay_per_use_rates, :providers
    remove_reference :pay_per_use_rates, :provider
  end

  def down
    add_reference :pay_per_use_rates, :provider, foreign_key: true
    remove_foreign_key :pay_per_use_rates, :plan
    remove_reference :pay_per_use_rates, :plan
  end
end
