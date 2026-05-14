# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :provider
  has_many :ampere_based_rates, dependent: :destroy
  has_many :usage_based_rates, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def base_price_for(ampere)
    ampere_based_rates.detect { |r| r.ampere == ampere }&.rate
  end
end
