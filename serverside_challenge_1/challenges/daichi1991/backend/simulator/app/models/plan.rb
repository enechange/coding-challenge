class Plan < ApplicationRecord
  has_many :basic_charges
  has_many :commodity_charges

  validates :plan, presence: true
  validates :company, presence: true
  
end
