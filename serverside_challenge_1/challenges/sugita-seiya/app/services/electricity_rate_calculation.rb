class ElectricityRateCalculation

  def self.calculation_electricity_charge(plan, electron_info)
    basic_charge = calculation_basic_charge(plan, electron_info)

    if basic_charge.blank?
      return nil
    end

    usage_charge = calculation_usage_charge(plan, electron_info)

    # 小数点以下切り捨て
    (basic_charge + usage_charge).floor
  end

  # 基本料金の計算
  def self.calculation_basic_charge(target_plan, electron_info)
    target_basic_charge = target_plan.basic_charges.find do |basic_charge|
      basic_charge.contract_amperage == electron_info.contract_amperage
    end
    if target_basic_charge.blank?
      return nil
    end

    target_basic_charge.charge_unit_price
  end

  # 従量料金の計算
  def self.calculation_usage_charge(target_plan, electron_info)
    user_usage = electron_info.electricity_usage
    total_charge = 0
    plan_diff_usage = 0

    target_plan.usage_charges.sort_by(&:minimum_usage).each do |plan_usage_charge|
      minimum_usage = plan_usage_charge.minimum_usage
      max_usage = plan_usage_charge.max_usage
      charge_unit_price = plan_usage_charge.charge_unit_price

      if minimum_usage && max_usage
        plan_diff_usage = max_usage - minimum_usage
      end

      # 従量料金がないプランの計算
      if minimum_usage.zero? && max_usage.nil?
        return user_usage * charge_unit_price
      end

      # 従量料金があるプランの計算
      if (user_usage <= plan_diff_usage) || (minimum_usage !=0 && max_usage.nil?)
        return total_charge + user_usage * charge_unit_price
      end

      user_usage -= plan_diff_usage
      total_charge += plan_diff_usage * charge_unit_price
    end
  end
end
