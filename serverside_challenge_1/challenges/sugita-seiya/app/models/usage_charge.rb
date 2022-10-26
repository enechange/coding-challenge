class UsageCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :minimum_usage,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 },
            uniqueness: { scope: %i[electricity_rate_plan_id max_usage], message: 'プラン、区分（最大値、最小値）の組み合わせは存在します。' }

  validates :electricity_rate_plan_id,
            presence: true

  validate :check_minimum_is_not_over_maximum

  def check_minimum_is_not_over_maximum
    if minimum_usage.blank? || max_usage.blank?
      return
    end

    if max_usage <= minimum_usage
      errors.add(:minimum_usage, '最大値未満の数値を入力してください。')
    end
  end
end
