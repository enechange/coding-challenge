# frozen_string_literal: true

class ElectricPlan
  def initialize(provider, plan)
    @data = InitializeChargePlan.new(provider, plan)
  end

  def total_charge(ampere, usage)
    (basic_charge(ampere) + usage_charge(usage)).floor
  end

  def provider_info
    { @data.provider => @data.plan }
  end

  protected

  def basic_charge(ampere)
    @data.basic_charges[ampere]
  end

  def usage_charge(usage)
    charge = 0
    @data.tiers.each do |limit, rate|
      if usage > limit
        charge += (limit * rate)
        usage -= limit
      else
        charge += (usage * rate)
        break
      end
    end
    charge
  end
end
