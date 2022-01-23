class Company < ApplicationRecord
    has_many :plans
    validates :name, presence: true
end
