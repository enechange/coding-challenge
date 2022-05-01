class Plan < ApplicationRecord
  validates :provider_id, presence: true
  validates :name, presence: true, uniqueness: true
end
