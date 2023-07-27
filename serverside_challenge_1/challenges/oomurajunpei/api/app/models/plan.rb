class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates, dependent: :destroy
  has_many :pay_per_use_rates, dependent: :destroy

  validates :name, presence: true
end
