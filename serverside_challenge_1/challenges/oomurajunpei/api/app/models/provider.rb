class Provider < ApplicationRecord
  has_many :basic_rates, dependent: :destroy
  has_many :pay_per_use_rates, dependent: :destroy
end
