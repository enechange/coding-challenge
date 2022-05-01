class Plan < ApplicationRecord
  belongs_to :provider

  validates :provider_id, presence: true
  validates :name, presence: true, uniqueness: true
end
