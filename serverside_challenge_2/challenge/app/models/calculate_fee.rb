# frozen_string_literal: true

class CalculateFee
  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage.to_i
  end

  def self.call(ampere, usage)
    new(ampere, usage).call
  end

  def call
    array = []
    Plan.find_each do |plan|
      price = calculate_price(plan)
      next if price.blank?

      array.push({ providerName: plan.provider.name, planName: plan.name,
                   price: })
    end
    array
  end

  private

  attr_reader :ampere, :usage

  def calculate_price(plan)
    basic_price, unit_price = find_base_price(plan)
    return nil if basic_price.blank?

    usage_tier_price(basic_price, unit_price, plan)
  end

  def find_base_price(plan)
    basic_price = plan.basic_monthly_fees.find_by(contract_amperage: ampere)
    # 基本料金が契約アンペア数によっては存在しないパターンがあり、nil ガードのため
    return [nil, nil] if basic_price.blank?

    electricity_usage = plan.electricity_usages.where(from: ..usage,
                                                      to: usage...).or(plan.electricity_usages.where(
                                                                         from: ..usage, to: nil
                                                                       )).take
    # 電気代が存在しないパターンもあり、nil ガードのため
    return [nil, nil] if electricity_usage.blank?

    [basic_price.price, electricity_usage.unit_price]
  end

  def usage_tier_price(basic_price, unit_price, plan)
    first_usage = plan.electricity_usages.first
    # MEMO: https://denki.docomo.ne.jp/article/26_calculation.html#:~:text=%E9%9B%BB%E5%8A%9B%E4%BC%9A%E7%A4%BE%E3%81%AB%E3%82%88%E3%81%A3%E3%81%A6%E3%81%AF%E3%80%811kWh%E3%81%94%E3%81%A8%E3%81%AB%E5%AE%9A%E3%82%81%E3%82%89%E3%82%8C%E3%82%8B%E9%9B%BB%E5%8A%9B%E9%87%8F%E6%96%99%E9%87%91%E3%81%AE%E5%8D%98%E4%BE%A1%E3%82%923%E6%AE%B5%E9%9A%8E%E3%81%AB%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B%E3%80%8C%E4%B8%89%E6%AE%B5%E9%9A%8E%E6%96%99%E9%87%91%E3%80%8D%E3%81%AE%E4%BB%95%E7%B5%84%E3%81%BF%E3%82%92%E5%B0%8E%E5%85%A5%E3%81%97%E3%81%A6%E3%81%84%E3%82%8B%E5%A0%B4%E5%90%88%E3%82%82%E3%81%82%E3%82%8B
    # MEMO: 段階料金がないプランも存在するため、ガードのために入れてます
    # TODO: 段階料金がないプランを登録するときのバリデーションが入れば、`first_usage.to.blank?` は削除する
    return (basic_price + unit_price * usage.to_i).floor if first_usage.to.blank? || usage <= first_usage.to

    first_price = first_usage.unit_price * first_usage.to
    second_usage = plan.electricity_usages[1]
    return (basic_price + first_price + (usage - first_usage.to) * unit_price).floor if usage <= second_usage.to

    second_price = second_usage.unit_price * (second_usage.to - first_usage.to)

    (basic_price + first_price + second_price + (usage - second_usage.to) * unit_price).floor
  end
end
