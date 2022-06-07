class CalculateElectricity
  attr_accessor :ampere, :usage, :result

  def initialize(params)
    @ampere = params[:ampere].to_i
    @usage = params[:usage].to_i
    @result = simulate_electricity_charge
  end

  def simulate_electricity_charge
    target_plans = BaseCharge.where(ampere: @ampere)
    prices = target_plans.map do |target_plan|
      res = (base_charge(target_plan.plan) + electricity_charge(target_plan.plan))
      { price: res, plan_name: target_plan.plan.name, provider_name: target_plan.plan.provider.name }
    end
  end

  private

  def base_charge(plan)
    BaseCharge.find_by(plan_id: plan.id, ampere: @ampere).base_charge
  end

  def electricity_charge(plan)
    PerUseCharge.where(plan: plan).where('min_usage <= ?', @usage).inject(0) do |electricity_charge, t|
      if (@usage - t.min_usage) <= (t.max_usage - t.min_usage)
        electricity_charge + (t.per_use_charge * (@usage - t.min_usage))
      else
        electricity_charge + (t.per_use_charge * (t.max_usage - t.min_usage))
      end
    end
  end
end
