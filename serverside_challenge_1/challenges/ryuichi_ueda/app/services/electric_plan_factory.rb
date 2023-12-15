# frozen_string_literal: true

class ElectricPlanFactory
  def self.create(provide, plan)
    ElectricPlan.new(provide, plan)
  end
end
