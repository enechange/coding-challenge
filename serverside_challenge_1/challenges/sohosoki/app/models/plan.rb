class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_charges
  has_many :pay_as_you_go_fees
end
