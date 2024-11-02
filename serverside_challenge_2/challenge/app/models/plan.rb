# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_prices, dependent: :destroy
  has_many :measured_rates, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :provider, presence: true, uniqueness: { scope: :name }
end
