class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_fees

  validates :name, presence: true
end
