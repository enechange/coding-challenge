# frozen_string_literal: true

class BasicPrice < ApplicationRecord
  belongs_to :plan

  AMPERAGE_LIST = [ 10, 15, 20, 30, 40, 50, 60 ].freeze

  validates :amperage, presence: true, inclusion: { in: AMPERAGE_LIST }
  validates :price, numericality: { only_numeric: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99999.99 }
  validates :plan, presence: true, uniqueness: { scope: :amperage }
end
