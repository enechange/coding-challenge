# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  ampere     :integer          not null
#  charge     :decimal(10, 2)   not null
#  state      :integer          default("active"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
#
class BasicCharge < ApplicationRecord
  VALID_AMPERES = [ 10, 15, 20, 30, 40, 50, 60 ].freeze

  belongs_to :plan

  enum :state, {
    inactive: 0,
    active:   1
  }, prefix: true

  validates :ampere, presence: true, inclusion: { in: VALID_AMPERES }
  validates :charge, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
