# frozen_string_literal: true

class ElectricityRateSimulation
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeMethods::BeforeTypeCast

  attribute :amperage, :integer
  attribute :usage_kwh, :integer

  validates :amperage, presence: true, numericality: { only_integer: true }
  validates :amperage, inclusion: { in: [10, 15, 20, 30, 40, 50, 60] }
  validates :usage_kwh, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def initialize(amperage, usage_kwh)
    super(amperage:, usage_kwh:)
  end

  def execute
    ElectricityPlan.preload(:provider, :basic_rates, :usage_rates).map do |plan|
      calculate_rate_plan(plan)
    end
  end

  def calculate_rate_plan(plan)
    return SimulationResult.not_found_basic_amperage(plan) if plan.basic_rates.find_by(amperage:).blank?

    total_amount = plan.calculate_total_amount(amperage, usage_kwh)

    SimulationResult.new(plan.provider.name, plan.name, total_amount)
  end
end
