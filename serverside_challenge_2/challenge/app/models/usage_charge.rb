# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id          :bigint           not null, primary key
#  charge      :decimal(10, 2)   not null
#  lower_limit :integer          not null
#  state       :integer          default("active"), not null
#  upper_limit :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plan_id     :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
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
