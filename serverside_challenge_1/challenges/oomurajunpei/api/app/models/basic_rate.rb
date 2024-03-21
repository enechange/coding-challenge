class BasicRate < ApplicationRecord
  belongs_to :plan

  validates :ampere, presence: true
  validates :price, presence: true
end
