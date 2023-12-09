# frozen_string_literal: true

class ProviderService
  include Constants
  def self.calculate(ampere, usage)
    results = {
      tokyo_electric: TokyoElectricPlan.new.total_charge(ampere, usage),
      loop: LoopPlan.new.total_charge(ampere, usage)
    }
    additional_plans(results, ampere, usage) if more_than_30_ampere?(ampere)
    results
  end

  def self.providers_info(ampere)
    info = {
      tokyo_electric: TokyoElectricPlan.new.provider_info,
      loop: LoopPlan.new.provider_info
    }
    additional_infos(info) if more_than_30_ampere?(ampere)
    info
  end

  def self.additional_plans(results, ampere, usage)
    results[:tokyo_gas] = TokyoGasPlan.new.total_charge(ampere, usage)
    results[:jxtg] = JxtgPlan.new.total_charge(ampere, usage)
  end

  def self.additional_infos(info)
    info[:tokyo_gas] = TokyoGasPlan.new.provider_info
    info[:jxtg] = JxtgPlan.new.provider_info
  end

  def self.more_than_30_ampere?(ampere)
    VALID_AMPERES_MORE_THAN_30.include?(ampere)
  end
end
