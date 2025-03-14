# frozen_string_literal: true

class ElectricityChargesBasicRate < ApplicationRecord
  belongs_to :plan

  validates :basic_rate, presence: true
  validates :ampere, presence: true, uniqueness: { scope: :plan_id }
end
