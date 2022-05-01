class Provider < ApplicationRecord
  has_many :plan

  validates :name, presence: true, uniqueness: true
end
