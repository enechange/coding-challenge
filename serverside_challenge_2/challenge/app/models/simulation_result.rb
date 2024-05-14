# frozen_string_literal: true

class SimulationResult
  attr_reader :provider_name, :plan_name, :price, :error_message

  def initialize(provider_name, plan_name, price, error_message = nil)
    @provider_name = provider_name
    @plan_name = plan_name
    @price = price
    @error_message = error_message
  end
end
