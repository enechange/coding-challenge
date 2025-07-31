# frozen_string_literal: true

class PowerSupplyPlan < ApplicationRecord
  belongs_to :provider
  has_many :meter_rate_charges
  has_many :basic_charges

  def calculate_total_amount(amp, meter_rate)
    basic_charge_record = basic_charges.where(amp: amp)
    return nil if basic_charge_record.blank?

    basic_charge_amount = basic_charge_record.first.price.to_f
    meter_rate_charge_amount = calculate_meter_rate_charge(meter_rate)
    (basic_charge_amount + meter_rate_charge_amount).floor(0).to_i
  end

  def calculate_meter_rate_charge(meter_rate)
    total_meter_rate_charges = 0

    meter_rate_charges.each do |step|
      total_meter_rate_charges += step.calculate_charge(meter_rate.to_i)
    end
    total_meter_rate_charges
  end
end
