class Company < ApplicationRecord
    has_many :plans
    validates :id, presence: true, uniqueness: true
    validates :name, presence: true
end
