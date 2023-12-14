# frozen_string_literal: true

class ProviderService
  include Constants
  def self.calculate(ampere, usage)
    results = {
      tokyo_electric: ElectricPlanFactory.create('東京電力エナジーパートナー').total_charge(ampere, usage),
      loop: ElectricPlanFactory.create('Loopでんき').total_charge(ampere, usage)
    }
    additional_plans(results, ampere, usage) if more_than_30_ampere?(ampere)
    results
  end

  def self.providers_info(ampere)
    info = {
      tokyo_electric: ElectricPlanFactory.create('東京電力エナジーパートナー').provider_info,
      loop: ElectricPlanFactory.create('Loopでんき').provider_info
    }
    additional_infos(info) if more_than_30_ampere?(ampere)
    info
  end

  def self.additional_plans(results, ampere, usage)
    results[:tokyo_gas] = ElectricPlanFactory.create('東京ガス株式会社').total_charge(ampere, usage)
    results[:jxtg] = ElectricPlanFactory.create('JXTGでんき').total_charge(ampere, usage)
  end

  def self.additional_infos(info)
    info[:tokyo_gas] = ElectricPlanFactory.create('東京ガス株式会社').provider_info
    info[:jxtg] = ElectricPlanFactory.create('JXTGでんき').provider_info
  end

  def self.more_than_30_ampere?(ampere)
    VALID_AMPERES_MORE_THAN_30.include?(ampere)
  end
end
