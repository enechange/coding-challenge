# frozen_string_literal: true

class ElectricityPlansSimulator
  attr_reader :plans, :consumption, :contract_amperage

  def initialize(plans:, consumption:, contract_amperage:)
    @plans = plans
    @consumption = consumption
    @contract_amperage = contract_amperage
  end

  def calculate_results
    covered_plans = plans.select { |plan| plan.for_amperage?(contract_amperage.to_i) }
    covered_plans.map do |plan|
      { provider_name: plan.provider.name,
        plan_name: plan.name,
        price: plan.calculate_price(contract_amperage.to_i, consumption.to_i) }
    end
  end

  def validate_params
    errors = []
    errors.concat validate_consumption
    errors.concat validate_contract_amperage
    errors
  end

  private

  def validate_consumption
    errors = []

    if consumption.blank?
      errors << { code: :consumption_is_required,
                  message: 'Consumption is required' }
    elsif !non_negative_integer?(consumption)
      errors << { code: :invalid_consumption,
                  message: 'Consumption must be non negative integer' }
    end

    errors
  end

  def validate_contract_amperage
    errors = []
    valid_contract_amperages = [10, 15, 20, 30, 40, 50, 60]

    if contract_amperage.blank?
      errors << { code: :contract_amperage_is_required,
                  message: 'Contract amperage is required' }
    elsif !non_negative_integer?(contract_amperage) || !valid_contract_amperages.include?(contract_amperage.to_i)
      errors << { code: :invalid_contract_amperage,
                  message: 'Contract amperage is invalid' }
    end

    errors
  end

  def non_negative_integer?(param)
    param.to_s.match?(/\A[0-9]+\z/) && param.to_i >= 0
  end
end
