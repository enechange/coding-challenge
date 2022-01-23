class Plan < ApplicationRecord
  belongs_to :company
  has_many :basic_fees
  has_many :usage_charges
  validates :name, presence: true
end
