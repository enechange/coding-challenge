class Provider < ApplicationRecord
  has_many :plans, foreign_key: "provider_code", dependent: :destroy
  validates :provider_code, presence: true
  validates :provider_name, presence: true
end
