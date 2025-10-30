# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  amount     :decimal(8, 2)    not null
#  ampere     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id             (plan_id)
#  index_basic_charges_on_plan_id_and_ampere  (plan_id,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
class BasicCharge < ApplicationRecord
  include CsvImportable
  MAX_AMOUNT = 999_999.99

  belongs_to :plan

  validates :ampere,
    presence: true,
    uniqueness: { scope: :plan_id },
    numericality: {
      only_integer: true,
      greater_than: 0,
      less_than_or_equal_to: INTEGER_MAX,
    }
  validates :amount,
    presence: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: MAX_AMOUNT,
    }

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
      %w[plan_code ampere amount]
    end

    def csv_upsert_unique_keys
      %w[plan_id ampere]
    end
  end
end
