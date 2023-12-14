# frozen_string_literal: true

class ElectricPlanFactory
  def self.create(provider_name)
    ElectricPlan.new(provider_name)
  end
end
