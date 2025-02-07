# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UsageCharge < ApplicationRecord
  belongs_to :plan

  enum :state, {
    inactive: 0,
    active:   1
  }, prefix: true

  validates :lower_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :upper_limit, numericality: { greater_than: :lower_limit }, allow_nil: true
  validates :charge, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
