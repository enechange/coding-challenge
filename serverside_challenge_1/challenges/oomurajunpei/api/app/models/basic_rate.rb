class BasicRate < ApplicationRecord
  belongs_to :provider

  validates :ampere, presence: true
  validates :price, presence: true
end
