class UsageCharge < ApplicationRecord
  belongs_to :plan, primary_key: :code, foreign_key: :plan_code

  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :usage_lower, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :usage_upper, numericality: { only_integer: true, greater_than: :usage_lower }, allow_nil: true
  validate :no_overlapping_ranges

  # @param usage [Integer] 電気使用量(kWh)
  scope :lower_than, ->(usage) { where("usage_lower <= ?", usage) }

  # 従量料金 = 従量料金単価(円/kWh) × 電気使用量(kWh)
  #   ※ 計算で用いる 電気使用量(kWh) は、usage（またはusage_upper） - usage_lower で計算する
  # @param usage [Integer] 電気使用量(kWh)
  # @return [BigDecimal] 従量料金(円)
  def calc_charge(usage)
    return 0.0 if usage_lower >= usage

    upper = usage_upper.present? && usage_upper < usage ? usage_upper : usage
    applicable_usage = upper - usage_lower
    unit_price * applicable_usage
  end

  private

  # 同じ料金プラン内で、電気使用量の範囲が重複しないこと
  # upper_usageと次のlower_usageが重複しても良い (例: 0-120, 120-300)
  # NOTE: usage_upper = nullの場合は上限なしとみなす
  def no_overlapping_ranges
    max_usage = 2_147_483_647 # PostgreSQL INTEGER 最大値
    upper = usage_upper || max_usage

    overlapping = UsageCharge.where(plan_code:).where.not(id:)
      .where("(usage_lower < ? AND (usage_upper IS NULL OR usage_upper > ?))",
            upper,
            usage_lower)

    return unless overlapping.exists?

    errors.add(:base, "overlapping usage range exists")
  end
end

# == Schema Information
#
# Table name: usage_charges
#
#  id                                :bigint           not null, primary key
#  code                              :string           not null
#  plan_code                         :string           not null
#  unit_price(従量料金単価(円/kWh))  :decimal(10, 2)   not null
#  usage_lower(電気使用量(kWh) 下限) :integer          not null
#  usage_upper(電気使用量(kWh) 上限) :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#
# Indexes
#
#  index_usage_charges_on_code                         (code) UNIQUE
#  index_usage_charges_on_plan_code_and_usage_range    (plan_code,usage_lower,usage_upper)
#  index_usage_charges_on_usage_lower_and_usage_upper  (usage_lower,usage_upper)
#
# Foreign Keys
#
#  fk_rails_...  (plan_code => plans.code)
#
