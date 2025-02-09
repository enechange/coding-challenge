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
      usage_fee = if usage_kwh.zero?
                    0
                  else
                    calculate_usage_fee(
                      plan,
                      usage_kwh
                    )
                  end

      total_fee = basic_fee + usage_fee
      results << { provider_name: plan.electricity_provider.name, plan_name: plan.name, price: total_fee }
    end
    results
  end

  def self.calculate_usage_fee(plan, usage_kwh)
    total_fee = 0

    usage_fees = plan.electricity_plan_usage_fees.where(min_usage: ...usage_kwh).order(min_usage: :asc)

    # 従量料金が変動する区間ごとに計算して合計に追加
    # 現在と次の値のセットのループ
    # ループの最後の(next_feeがない)場合は処理されない仕様なので、最後の値は別途計算する
    usage_fees.each_cons(2) do |current_fee, next_fee|
      next unless usage_kwh > current_fee.min_usage

      # 現在の区間の使用量を計算
      applicable_kwh = if current_fee.min_usage.zero?
                         # データ上区間が0-121のように表現されるため、この区間は120kWh分を計算したいが、単純に引き算をすると121kWhとなりズレる
                         # そのため、この区間の料金は1kWh少なく計算する調整を入れる
                         next_fee.min_usage - current_fee.min_usage - 1
                       else
                         next_fee.min_usage - current_fee.min_usage
                       end
      # 現在の区間の料金を合計に追加
      total_fee += applicable_kwh * current_fee.fee
    end

    # 最後の区間の料金を合計に追加
    total_fee += if usage_fees.size == 1
                   # 料金の区間が1つのみの場合、ループ内処理が実行されずapplicable_kwhから1を引く調整が入っていないため、ここでは調整を行わない
                   (usage_kwh - usage_fees.last.min_usage) * usage_fees.last.fee
                 else
                   (usage_kwh - usage_fees.last.min_usage + 1) * usage_fees.last.fee
                 end

    total_fee
  end
end
