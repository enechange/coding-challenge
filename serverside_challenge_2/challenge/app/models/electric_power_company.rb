# frozen_string_literal: true

class ElectricPowerCompany < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }, uniqueness: true
end
