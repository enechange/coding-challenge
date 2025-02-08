# frozen_string_literal: true

class ElectricityFeeCalculatorService
  def self.calculate_fees(contract_ampere, usage_kwh)
    results = []

    ElectricityPlan
      .includes(
        :electricity_provider,
        :electricity_plan_basic_fees,
        :electricity_plan_usage_fees
      )
      .find_each do |plan|
      basic_fee = plan.electricity_plan_basic_fees.find_by!(ampere: contract_ampere.to_s).fee
      usage_fee = calculate_usage_fee(
        plan.electricity_plan_usage_fees.where(min_usage: ...usage_kwh),
        usage_kwh
      )

      total_fee = basic_fee + usage_fee
      results << { provider_name: plan.electricity_provider.name, plan_name: plan.name, price: total_fee }
    end

    results
  end

  def self.calculate_usage_fee(usage_fees, usage_kwh)
    total_fee = 0

    # 従量料金が変動する区間ごとに計算して合計に追加
    # 現在と次の値のセットのループ
    # ループの最後の(next_feeがない)場合は処理されない仕様なので、最後の値は別途計算する
    usage_fees.order(min_usage: :asc).each_cons(2) do |current_fee, next_fee|
      next unless usage_kwh > current_fee.min_usage

      # 現在の区間の使用量を計算
      applicable_kwh = next_fee.min_usage - current_fee.min_usage
      # 現在の区間の料金を合計に追加
      total_fee += applicable_kwh * current_fee.fee
    end

    # 最後の区間の料金を合計に追加
    total_fee += (usage_kwh - usage_fees.last.min_usage) * usage_fees.last.fee

    total_fee
  end
end
