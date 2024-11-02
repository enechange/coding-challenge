# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :electric_power_company

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :electric_power_company, presence: true, uniqueness: { scope: :name }
end
