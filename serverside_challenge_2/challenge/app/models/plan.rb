# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :electric_power_company

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }, uniqueness: { scope: :electric_power_company_id }
end
