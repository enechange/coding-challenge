class Plan < ApplicationRecord
  belongs_to :company
  has_many :basic_fees
  has_many :usage_charges
  validates :name, presence: true

  scope :ampere, -> (ampere) { joins(:basic_fees).where(basic_fees: { ampere: ampere }) }
end
