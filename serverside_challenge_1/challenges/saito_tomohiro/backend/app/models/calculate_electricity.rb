class CalculateElectricity
  attr_accessor :ampere, :usage, :result

  def initialize(params)
    @ampere = params[:ampere].to_i
    @usage = params[:usage].to_i
    @result = simulate_electricity_charge
  end

  def simulate_electricity_charge
    targets = BaseCharge.where(ampere: @ampere)
    prices = targets.map do |target|
      res = (base_charge(target.plan) + electricity_charge(target.plan))
      { price: res, plan_name: target.plan.name, provider_name: target.plan.provider.name }
    end
  end

  private

  def base_charge(plan)
    BaseCharge.find_by(plan_id: plan.id, ampere: @ampere).base_charge
  end

  def electricity_charge(plan)
    PerUseCharge.where(plan: plan).where('min_usage <= ?', @usage).inject(0) do |electricity_charge, t|
      if t.max_usage.nil? || @usage <= t.max_usage
        electricity_charge + (t.per_use_charge * (@usage - t.min_usage))
      else
        electricity_charge + (t.per_use_charge * (t.max_usage - t.min_usage))
      end
    end
  end
end
