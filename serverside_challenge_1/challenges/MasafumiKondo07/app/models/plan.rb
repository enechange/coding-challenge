class Plan < ApplicationRecord
  belongs_to :company
  has_many :electricity_fees, dependent: :destroy
  has_many :basic_charges, dependent: :destroy
end
