# frozen_string_literal: true

class UsageBasedRate < ApplicationRecord
  belongs_to :plan

  validates :kilowatt_hour_low, presence: true,
                                numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :kilowatt_hour_high, presence: true,
                                 numericality: { only_integer: true, greater_than: 0 }
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :low_must_not_exceed_high

  private

  def low_must_not_exceed_high
    return if kilowatt_hour_low.nil? || kilowatt_hour_high.nil?
    return unless kilowatt_hour_low >= kilowatt_hour_high

    errors.add(:kilowatt_hour_low, :must_not_exceed_high)
  end
end
