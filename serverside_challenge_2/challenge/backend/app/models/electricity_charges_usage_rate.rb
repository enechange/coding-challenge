# frozen_string_literal: true

class ElectricityChargesUsageRate < ApplicationRecord
  belongs_to :plan

  validates :min_usage, :unit_rate, presence: true
  validates :max_usage, numericality: { greater_than: :min_usage }, allow_nil: true

  validate :validate_usage_ranges

  private

  def validate_usage_ranges
    # usageがplan内で重複しないかを確認する
    usage_ranges = fetch_existing_usage_ranges + [{ min: min_usage, max: max_usage }]
    usage_ranges.sort_by { |usage_range| usage_range[:min] }
    # puts usage_ranges

    # 使用量範囲の重複チェック
    validate_no_overlap_in_usage_ranges(usage_ranges)

    # 上限なしの範囲が複数存在しないかチェック
    validate_single_unbounded_range(usage_ranges)
  end

  def fetch_existing_usage_ranges
    ElectricityChargesUsageRate
      .where(plan: plan)
      .order(:min_usage)
      .pluck(:min_usage, :max_usage)
      .map { |min, max| { min: min, max: max } }
  end

  def validate_no_overlap_in_usage_ranges(usage_ranges)
    previous_max_usage = nil

    usage_ranges.each do |usage_range|
      if previous_max_usage.present? && usage_range[:min] < previous_max_usage
        errors.add(:base, '同一プラン内で使用量の範囲が他のレコードと重複しています')
        break
      end

      previous_max_usage = usage_range[:max]
    end
  end

  def validate_single_unbounded_range(usage_ranges)
    unbounded_count = usage_ranges.count { |usage_range| usage_range[:max].nil? }

    return unless unbounded_count > 1

    errors.add(:base, '同一プラン内で使用量上限がない項目が2つ以上存在します')
  end
end
