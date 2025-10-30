# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id         :bigint           not null, primary key
#  from_kwh   :integer          not null
#  to_kwh     :integer
#  unit_price :decimal(8, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id               (plan_id)
#  index_usage_charges_on_plan_id_and_from_kwh  (plan_id,from_kwh) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
class UsageCharge < ApplicationRecord
  include CsvImportable
  MAX_AMOUNT = 999_999.99
  belongs_to :plan

  validates :from_kwh, :unit_price, presence: true
  validates :from_kwh, uniqueness: { scope: :plan_id }
  validates :from_kwh, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: INTEGER_MAX,
  }
  validates :to_kwh, numericality: {
    only_integer: true,
    allow_nil: true,
  }
  validates :unit_price, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: MAX_AMOUNT,
  }
  validate :validate_to_kwh_greater_than_from_kwh
  validate :validate_range_must_not_overlap

  scope :for_usage, ->(usage) { where('from_kwh <= ?', usage) }

  class << self
    private

    def convert_attrs!(attrs)
      @plan_code_ids ||= Plan.pluck(:code, :id).to_h
      convert_code_to_id(
        attrs,
        code_key: 'plan_code',
        id_key: 'plan_id',
        target_mappings: @plan_code_ids,
      )
    end

    def csv_attributes
      %w[plan_code from_kwh to_kwh unit_price]
    end

    def csv_upsert_unique_keys
      %w[plan_id from_kwh]
    end
  end

  private

  def validate_to_kwh_greater_than_from_kwh
    return if to_kwh.blank? || from_kwh.blank?
    return if to_kwh > from_kwh

    errors.add(:to_kwh, "は#{self.class.human_attribute_name(:from_kwh)}より大きくなければなりません")
  end

  def validate_range_must_not_overlap
    return if from_kwh.blank?
    return if plan.blank?

    errors.add(:base, '使用量範囲が他の区分と重複しています') if overlapping_range_exists?
  end

  def overlapping_range_exists?
    plan.usage_charges
      .where.not(id: id)
      .where(
        '(from_kwh <= :to_kwh OR :to_kwh IS NULL)
        AND (:from_kwh <= to_kwh OR to_kwh IS NULL)',
        from_kwh: from_kwh,
        to_kwh: to_kwh,
      )
      .exists?
  end
end
