class HouseUser < ApplicationRecord
  has_many :energy_histories, dependent: :destroy
end
