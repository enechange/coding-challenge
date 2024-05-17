# frozen_string_literal: true

class SimulationResult
  attr_reader :provider_name, :plan_name, :total_amount, :error_message

  def initialize(provider_name, plan_name, total_amount, error_message = nil)
    @provider_name = provider_name
    @plan_name = plan_name
    @total_amount = total_amount
    @error_message = error_message
  end

  def self.not_found_basic_amperage(plan)
    new(plan.provider.name, plan.name, nil, 'アンペア数に対応する基本料金が見つからないため料金を計算できません')
  end
end
