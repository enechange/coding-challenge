class PayPerUseRate < ApplicationRecord
  belongs_to :plan

  validates :unit_price, presence: true
end
