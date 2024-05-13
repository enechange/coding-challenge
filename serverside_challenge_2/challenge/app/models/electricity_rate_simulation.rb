class ElectricityRateSimulation
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :amperage, :integer
  attribute :usage_kwh, :integer

  validates :amperage, presence: true, numericality: { only_integer: true }
  validates :amperage, inclusion: { in: [10, 15, 20, 30, 40, 50, 60], message: 'アンペア数は[10, 15, 20, 30, 40, 50, 60]のいずれかを指定してください' }
  validates :usage_kwh, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def initialize(amperage, usage_kwh)
    super(amperage: amperage, usage_kwh: usage_kwh)
  end

  def execute(params)
    amperage = params[:amperage].to_i
    usage_kwh = params[:usage_kwh].to_i

    provider_plans.map do |plan|
      calculate_rate_plan(plan, amperage, usage_kwh)
    end
  end

  def calculate_rate_plan(plan, amperage, usage_kwh)
    calculated_kwh = 0
    total_price = 0

    if plan["basic_rate"][amperage].blank?
      return SimulationResult.new(plan['provider_name'], plan['plan_name'], nil, 'アンペア数に対応する基本料金が見つからないため料金を計算できません')
    end

    # 基本料金
    total_price += plan["basic_rate"][amperage]

    # 従量料金
    plan["usage_rate"].each do |level, resource|
      uncalculated_kwh = usage_kwh - calculated_kwh
      calcuable_kwh = resource['limit'].to_i - calculated_kwh

      if resource['limit'] == nil || uncalculated_kwh <= calcuable_kwh
        total_price += uncalculated_kwh * resource['rate']
        break
      else
        total_price += calcuable_kwh * resource['rate']
        calculated_kwh += calcuable_kwh
      end
    end

    SimulationResult.new(plan['provider_name'], plan['plan_name'], total_price.floor)
  end

  def provider_plans
    tepco_metered_light_b = YamlLoader.tepco_metered_light_b
    tepco_standard_s = YamlLoader.tepco_standard_s
    tokyo_gas_more_electricity_1 = YamlLoader.tokyo_gas_more_electricity_1
    looop_home_plan = YamlLoader.looop_home_plan

    [tepco_metered_light_b, tepco_standard_s, tokyo_gas_more_electricity_1, looop_home_plan]
  end
end