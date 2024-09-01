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

    # 電気の従量料金に関しては、各会社でも一律で切り捨てにしているため、切り捨てにする
    # 参考: https://www.tepco.co.jp/ep/corporate/plan_h/pdf/2024minaoshisiryou_2.pdf
    (basic_price.price + electricity_usage.unit_price * usage.to_i).round
  end
end
