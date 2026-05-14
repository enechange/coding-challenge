# frozen_string_literal: true

class AmpereBasedRate < ApplicationRecord
  include ElectricityBillConstants

  belongs_to :plan

  validates :ampere, presence: true, inclusion: { in: VALID_AMPERES }
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
