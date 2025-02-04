class UsageRate < ApplicationRecord
  belongs_to :plan
  MIN_USAGE_KWH = 0

  validates :min_kwh, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_kwh, numericality: { only_integer: true, greater_than: :min_kwh }, allow_nil: true
  validates :price_per_kwh, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 指定されたプランIDと使用量に基づいて従量料金を計算するクラスメソッド
  # @param plan_id [Integer] プランID
  # @param usage_kwh [Integer] 1ヶ月の使用量(kWh)
  # @return [Integer] 計算された従量料金（円）
  def self.calculate_charge(plan_id, usage_kwh)
    usage_kwh = usage_kwh.round # 使用電力量を四捨五入
    usage_rates = where(plan_id: plan_id).order(:min_kwh)
    total_charge = 0 # 料金合計
    used_kwh = 0  # 計算済み電力量

    usage_rates.each do |usage_rate|
      break if used_kwh >= usage_kwh

      max_kwh = usage_rate.max_kwh || Float::INFINITY # nil の場合は無制限とする
      min_limit = [usage_rate.min_kwh, used_kwh + 1].max
      max_limit = [max_kwh, usage_kwh].min

      applicable_kwh = [max_limit - min_limit + 1, usage_kwh - used_kwh].min
      next if applicable_kwh <= 0

      total_charge += applicable_kwh * usage_rate.price_per_kwh
      used_kwh += applicable_kwh
    end

    total_charge
  end

end
