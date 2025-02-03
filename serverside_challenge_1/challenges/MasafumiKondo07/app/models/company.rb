class Company < ApplicationRecord
  has_many :plans, dependent: :destroy
end
