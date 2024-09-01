# frozen_string_literal: true

class CalculateFee
  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
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
    basic_price = plan.basic_monthly_fees.find_by(contract_amperage: ampere)
    # 基本料金が契約アンペア数によっては存在しないパターンがあり、nil ガードのため
    return if basic_price.blank?

    electricity_usage = plan.electricity_usages.where(from: ..usage,
                                                      to: usage...).or(plan.electricity_usages.where(
                                                                         from: ...usage, to: nil
                                                                       )).take
    # 電気代が存在しないパターンもあり、nil ガードのため
    return if electricity_usage.blank?

    (basic_price.price + electricity_usage.unit_price * usage.to_i).to_i
  end
end
