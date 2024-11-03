# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_prices, dependent: :destroy
  has_many :measured_rates, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :provider, presence: true, uniqueness: { scope: :name }

  class << self
    def calc_prices(amperage, electricity_usage_kwh)
      errors = check_parameters(amperage, electricity_usage_kwh)
      if errors.present?
        return { errors: {
          message: "リクエストパラメーターが正しくありません。",
          details: errors
        } }
      end

      plans = Plan.all.includes(:provider)
      basic_prices_hash = BasicPrice.calc_prices(amperage)
      measured_rates_hash = MeasuredRate.calc_prices(electricity_usage_kwh)
      response = plans.filter_map do |plan|
        basic_price = basic_prices_hash[plan.id]
        next if basic_price.nil?

        measured_rate_price = measured_rates_hash[plan.id]&.[](:price) || 0
        price = (basic_price + measured_rate_price).floor
        {
          plan: plan,
          provider: plan.provider,
          price: price
        }
      end
      { plans: response }
    end

    def check_parameters(amperage, electricity_usage_kwh)
      errors = [
        BasicPrice.check_amperage?(amperage),
        MeasuredRate.validate_electricity_usage?(electricity_usage_kwh)
      ]
      errors.select { |error| error[:is_error] }
            .map { |error| error[:error_object] }
    end
  end
end
