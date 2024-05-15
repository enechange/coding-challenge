# frozen_string_literal: true

class BasicRate < ApplicationRecord
  belongs_to :electricity_plan

  validates :amperage, presence: true, uniqueness: { scope: :electricity_plan_id }
  validates :rate, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0 }
end
