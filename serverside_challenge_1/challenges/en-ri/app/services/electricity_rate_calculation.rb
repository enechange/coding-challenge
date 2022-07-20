# frozen_string_literal: true

class ElectricityRateCalculation
  def self.calculation_electricity_charge(plan, user_electron_info)
    basic_charge = calculation_basic_charge(plan, user_electron_info)

    # プランを提供していない会社はレスポンスに含めない
    # ※契約アンペア数によってプランを提供していない会社もある
    return nil if basic_charge.blank?

    usage_charge = calculation_usage_charge(plan, user_electron_info)

    # 電気料金の合計は、小数点以下（銭）を切り捨て
    (basic_charge + usage_charge).floor
  end

  # 基本料金の計算
  def self.calculation_basic_charge(target_plan, user_electron_info)
    target_basic_charge = target_plan.basic_charges.find do |basic_charge|
      basic_charge.contract_amperage == user_electron_info.contract_amperage
    end

    return nil if target_basic_charge.blank?

    target_basic_charge.charge_unit_price
  end

  # 従量料金の計算
  def self.calculation_usage_charge(target_plan, user_electron_info)
    total_charge = 0
    user_usage = user_electron_info.electricity_usage.dup

    target_plan.usage_charges.sort_by(&:minimum_usage).each do |plan_usage_charge|
      # plan_usage_chargeの従量料金区分の最大値と最小値の差分を取得
      plan_diff_usage = plan_usage_charge.max_usage - plan_usage_charge.minimum_usage

      return total_charge + user_usage * plan_usage_charge.charge_unit_price if user_usage <= plan_diff_usage

      user_usage -= plan_diff_usage

      # 電気料金の取得
      total_charge += plan_diff_usage * plan_usage_charge.charge_unit_price
    end
  end
end
