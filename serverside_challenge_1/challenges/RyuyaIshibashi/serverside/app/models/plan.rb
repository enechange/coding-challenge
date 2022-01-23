class Plan < ApplicationRecord
  belongs_to :company
  has_many :basic_fees
  validates :name, presence: true
end
