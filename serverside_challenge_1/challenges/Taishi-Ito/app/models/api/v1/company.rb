class Api::V1::Company < ApplicationRecord
  has_many :plans, dependent: :destroy
end
