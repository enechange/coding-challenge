class UsageCharge < ApplicationRecord
  belongs_to :electricity_rate_plan

  validates :charge_unit_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :minimum_usage,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0 },
            uniqueness: { scope: [:electricity_rate_plan_id, :max_usage],
                          message: 'プラン、区分（最大値、最小値）の組み合わせは存在します' }

  validates :max_usage,
            presence: true,
            numericality: { only_integer: true,
                            less_than_or_equal_to: Constants::MAXIMUM_ELECTRICITY_USAGE }

  validates :electricity_rate_plan_id,
            presence: true

  validate :cannot_minimum_less_than_maximum,
           :cannot_maximum_greater_than_minimum,

    def cannot_minimum_less_than_maximum
      return if minimum_usage.blank? || max_usage.blank?

      if minimum_usage >= max_usage
        errors.add(:minimum_usage, '最大値未満の数値を入力してください。')
      end
    end

  def cannot_maximum_greater_than_minimum
    return if minimum_usage.blank? || max_usage.blank?

    if max_usage <= minimum_usage
      errors.add(:max_usage, '最小値より大きい数値を入力してください。')
    end
  end
end
