# frozen_string_literal: true

class ProviderService
  include Constants

  def self.calculate(ampere, usage)
    plan_infos = initialize_plans
    plans = select_plans(plan_infos, ampere)
    plans.to_h do |provider, plan|
      [provider, ElectricPlanFactory.create(provider, plan).total_charge(ampere, usage)]
    end
  end

  def self.providers_info(ampere)
    plan_infos = initialize_plans
    plans = select_plans(plan_infos, ampere)
    plans.to_h do |provider, plan|
      [provider, ElectricPlanFactory.create(provider, plan).provider_info]
    end
  end

  def self.more_than_30_ampere?(ampere)
    VALID_AMPERES_MORE_THAN_30.include?(ampere)
  end

  def self.select_plans(plan_infos, ampere)
    if more_than_30_ampere?(ampere)
      plan_infos
    else
      plan_infos.slice('東京電力エナジーパートナー', 'Loopでんき')
    end
  end

  def self.initialize_plans
    [
      ElectricPlanFactory.create('東京電力エナジーパートナー', '従量電灯B'),
      ElectricPlanFactory.create('Loopでんき', 'おうちプラン'),
      ElectricPlanFactory.create('東京ガス株式会社', 'ずっとも電気1'),
      ElectricPlanFactory.create('JXTGでんき', '従量電灯Bたっぷりプラン')
    ].map(&:provider_info).reduce({}, :merge)
  end
end
