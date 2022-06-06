class CalculateElectricity
  AMPERE = [10, 15, 20, 30, 40, 50, 60]
  MAX_USAGE = 99_999
  attr_accessor :plan, :ampere, :usage

  def initialize(plan, ampere, usage)
    @plan = plan
    @ampere = ampere.to_i
    @usage = usage.to_i
  end

  def simulate_electricity_charge
    base_charge.nil? ? nil : (base_charge + electricity_charge)
  end

  private

  def base_charge
    res = BaseCharge.find_by(plan_id: @plan[:id], ampere: @ampere)
    res.nil? ? nil : res.base_charge
  end

  def electricity_charge
    PerUseCharge.where(plan: @plan).where('min_usage <= ?', @usage).inject(0) do |electricity_charge, t|
      if (@usage - t.min_usage) <= (t.max_usage - t.min_usage)
        electricity_charge + (t.per_use_charge * (@usage - t.min_usage))
      else
        electricity_charge + (t.per_use_charge * (t.max_usage - t.min_usage))
      end
    end
  end
end
