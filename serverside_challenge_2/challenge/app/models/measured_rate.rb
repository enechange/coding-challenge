# frozen_string_literal: true

class MeasuredRate < ApplicationRecord
  MAX_SMALL_INT_VALUE = 32767

  belongs_to :plan

  validates :electricity_usage_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SMALL_INT_VALUE }
  validates :electricity_usage_max, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: MAX_SMALL_INT_VALUE }
  validates :price, numericality: { only_numeric: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99999.99 }
  validates :plan, presence: true
  validate :validate_max_greater_than_min
  validate :validate_electricity_usage

  def electricity_usage_max=(value)
    super(value.nil? ? MAX_SMALL_INT_VALUE : value)
  end

  private

  def validate_max_greater_than_min
    return if electricity_usage_max.nil? || electricity_usage_min.nil?

    if electricity_usage_max < electricity_usage_min
      errors.add(:electricity_usage_max, "must be greater than or equal to electricity_usage_min")
    end
  end

  def validate_electricity_usage
    return if electricity_usage_max.nil? || electricity_usage_min.nil?

    rates = self.class.where(plan: plan).where.not(id: id)
    validate_electricity_usage_min(rates)
    validate_electricity_usage_max(rates)
    validate_electricity_usage_contain(rates)
  end

  def validate_electricity_usage_min(rates)
    if rates.find { |rate| rate.electricity_usage_min <= electricity_usage_min && electricity_usage_min <= rate.electricity_usage_max }.present?
      errors.add(:electricity_usage_min, "range overlaps with an existing range")
    end
  end

  def validate_electricity_usage_max(rates)
    if rates.find { |rate| rate.electricity_usage_min <= electricity_usage_max && electricity_usage_max <= rate.electricity_usage_max }.present?
      errors.add(:electricity_usage_max, "range overlaps with an existing range")
    end
  end

  def validate_electricity_usage_contain(rates)
    if rates.find { |rate| electricity_usage_min <= rate.electricity_usage_min && rate.electricity_usage_max <= electricity_usage_max }.present?
      errors.add(:electricity_usage_max, "range overlaps with an existing range")
    end
  end
end
