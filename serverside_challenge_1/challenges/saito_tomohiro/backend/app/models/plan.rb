class Plan < ApplicationRecord
  has_many :base_charges
  has_many :per_use_charges
  belongs_to :provider
  validates :name, presence: true, uniqueness: true
end
