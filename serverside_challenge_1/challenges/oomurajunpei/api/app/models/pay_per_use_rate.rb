class PayPerUseRate < ApplicationRecord
  belongs_to :provider

  validates :unit_price, presence: true
end
