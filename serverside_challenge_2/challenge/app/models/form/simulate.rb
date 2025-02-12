# frozen_string_literal: true

class Form::Simulate
  include ActiveModel::Model

  attr_accessor :ampere, :usage

  validates :ampere, presence: true, inclusion: { in: ->(electricity_charge) { BasicCharge::VALID_AMPERES.map(&:to_s) } }
  validates :usage, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
