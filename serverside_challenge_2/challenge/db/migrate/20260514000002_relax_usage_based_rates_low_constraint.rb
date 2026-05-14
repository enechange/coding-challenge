# frozen_string_literal: true

class RelaxUsageBasedRatesLowConstraint < ActiveRecord::Migration[7.0]
  def change
    remove_check_constraint :usage_based_rates, name: 'usage_based_rates_low_positive'
    add_check_constraint :usage_based_rates,
                         'kilowatt_hour_low >= 0',
                         name: 'usage_based_rates_low_non_negative'
  end
end
