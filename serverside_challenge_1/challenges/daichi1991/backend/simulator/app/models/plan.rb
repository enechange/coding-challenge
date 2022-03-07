class Plan < ApplicationRecord
  has_many :basic_charges
  has_many :commodity_charges
end
