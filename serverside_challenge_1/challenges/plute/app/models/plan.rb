class Plan < ApplicationRecord
  belongs_to :provider
  has_many :base_fees
  has_many :usage_fees

  validates :provider_id, presence: true
  validates :name, presence: true, uniqueness: true
end
