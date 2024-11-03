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

  class << self
    def calc_prices(electricity_usage_kwh)
      rows = MeasuredRate.where("electricity_usage_min <= ?", electricity_usage_kwh).includes(:plan)
      rows.inject({}) do |sum, row|
        sum[row.plan_id] ||= { price: 0 }
        sum[row.plan_id][:price] += row.calc_row_price(electricity_usage_kwh)
        sum
      end
    end

    def validate_electricity_usage?(electricity_usage)
      res = { is_error: !electricity_usage.is_a?(Integer) }
      res[:error_object] = { field: "electricity_usage_kwh", message: "整数を指定してください。" } if res[:is_error]
      res
    end
  end

  def calc_row_price(electricity_usage_kwh)
    return 0 if electricity_usage_kwh.to_i.zero?

    min = self.electricity_usage_min_for_calc
    max = self.electricity_usage_max <= electricity_usage_kwh ?
            self.electricity_usage_max :
            electricity_usage_kwh
    (max - min) * self.price
  end

  private

  def electricity_usage_min_for_calc
    self.electricity_usage_min.zero? ? 0 : self.electricity_usage_min - 1
  end

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
