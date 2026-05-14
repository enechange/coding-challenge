# frozen_string_literal: true

class TightenUsageBasedRatesRangeConstraint < ActiveRecord::Migration[7.0]
  def up
    remove_check_constraint :usage_based_rates, name: 'usage_based_rates_low_le_high'
    add_check_constraint :usage_based_rates,
                         'kilowatt_hour_low < kilowatt_hour_high',
                         name: 'usage_based_rates_low_lt_high'
  end

  def down
    remove_check_constraint :usage_based_rates, name: 'usage_based_rates_low_lt_high'
    add_check_constraint :usage_based_rates,
                         'kilowatt_hour_low <= kilowatt_hour_high',
                         name: 'usage_based_rates_low_le_high'
  end
end
