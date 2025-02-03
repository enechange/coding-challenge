class UsageRate < ApplicationRecord
  belongs_to :plan
  MIN_USAGE_KWH = 0

  validates :min_kwh, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_kwh, numericality: { only_integer: true, greater_than: :min_kwh }, allow_nil: true
  validates :price_per_kwh, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.calculate_charge(plan_id, usage_kwh)
    usage_kwh = usage_kwh.round # 使用電力量を四捨五入
    rates = where(plan_id: plan_id).order(:min_kwh)
    total_charge = 0 # 料金合計
    used_kwh = 0  # 使用済み電力量

    rates.each do |rate|
      break if used_kwh >= usage_kwh

      max_kwh = rate.max_kwh || Float::INFINITY # nil の場合は無制限とする

      min_limit = rate.min_kwh.zero? ? 1 : [rate.min_kwh, used_kwh + 1].max
      max_limit = [max_kwh, usage_kwh].min

      applicable_kwh = [[max_limit - min_limit + 1, usage_kwh - used_kwh].min, 0].max

      next if applicable_kwh <= 0

      charge = applicable_kwh * rate.price_per_kwh
      total_charge += charge
      used_kwh += applicable_kwh

      # デバッグ用出力
      puts "Rate: #{rate.min_kwh}-#{rate.max_kwh}, Applicable KWh: #{applicable_kwh}, Used KWh: #{used_kwh}, Charge: #{charge}, Total: #{total_charge}"
    end

    total_charge
  end

end
