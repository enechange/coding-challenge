# frozen_string_literal: true

class ElectricityPlan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates, dependent: :destroy
  has_many :usage_rates, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :provider_id }
end
