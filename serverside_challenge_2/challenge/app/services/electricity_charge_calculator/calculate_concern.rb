# frozen_string_literal: true

module ElectricityChargeCalculator::CalculateConcern
  extend ActiveSupport::Concern

  def basic_charge
    plan.basic_charges.find_by!(ampere: ampere).charge
  rescue ActiveRecord::RecordNotFound
    raise App::DataNotFound, "Basic charge not found for #{ampere}A"
  end

  def usage_charge
    total_charge    = 0.0
    remaining_usage = 0

    plan.usage_charges.order(:lower_limit).each_with_index do |usage_charge|
      if usage_charge.upper_limit.nil? || usage <= usage_charge.upper_limit
        total_charge += (usage - remaining_usage) * usage_charge.charge
        break
      else
        offset = usage_charge.lower_limit.zero? ? 0 : 1
        total_charge += (usage_charge.upper_limit - usage_charge.lower_limit + offset) * usage_charge.charge
        remaining_usage = usage_charge.upper_limit
        next
      end
    end

    raise App::DataNotFound, "Usage charge not found for #{usage}kWh" unless total_charge.positive?

    total_charge
  end
end
