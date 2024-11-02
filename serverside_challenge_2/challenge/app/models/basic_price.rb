# frozen_string_literal: true

class BasicPrice < ApplicationRecord
  belongs_to :plan

  AMPERAGE_LIST = [ 10, 15, 20, 30, 40, 50, 60 ].freeze

  validates :amperage, presence: true, inclusion: { in: AMPERAGE_LIST }
  validates :price, numericality: { only_numeric: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 99999.99 }
  validates :plan, presence: true, uniqueness: { scope: :amperage }

  class << self
    def calculate_prices(amperage)
      rows = BasicPrice.where(amperage: amperage)
      rows.inject({}) do |sum, row|
        sum[row.plan_id] = row.price
        sum
      end
    end

    def check_amperage?(amperage)
      res = { is_error: !AMPERAGE_LIST.include?(amperage) }
      res[:error_object] = { field: "amperage", message: "#{AMPERAGE_LIST.join('/')}のいずれかを指定してください。" } if res[:is_error]
      res
    end
  end
end
