class ChangeReferenceFromBasicRates < ActiveRecord::Migration[7.0]
  def up
    add_reference :basic_rates, :plan, foreign_key: true
    remove_foreign_key :basic_rates, :providers
    remove_reference :basic_rates, :provider
  end

  def down
    add_reference :basic_rates, :provider, foreign_key: true
    remove_foreign_key :basic_rates, :plan
    remove_reference :basic_rates, :plan
  end
end
