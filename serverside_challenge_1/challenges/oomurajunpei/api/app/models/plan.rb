class Plan < ApplicationRecord
  belongs_to :provider
  has_many :basic_rates, dependent: :destroy
  has_many :pay_per_use_rates, dependent: :destroy

  validates :name, presence: true

  # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
  def calculate_pay_per_use_price(electricity_usage)
    pay_per_use_price = 0
    pay_per_use_rates.each do |pay_per_use_rate|
      break if pay_per_use_rate.min_electricity_usage.present? && electricity_usage <= pay_per_use_rate.min_electricity_usage

      adjustment_number = pay_per_use_rate.min_electricity_usage&.zero? ? 0 : 1
      pay_per_use_price += if pay_per_use_rate.min_electricity_usage.nil?
                             pay_per_use_rate.unit_price * electricity_usage
                           elsif pay_per_use_rate.max_electricity_usage.present? && electricity_usage > pay_per_use_rate.max_electricity_usage
                             pay_per_use_rate.unit_price * (pay_per_use_rate.max_electricity_usage - pay_per_use_rate.min_electricity_usage + adjustment_number)
                           else
                             pay_per_use_rate.unit_price * (electricity_usage - pay_per_use_rate.min_electricity_usage + adjustment_number)
                           end
    end
    pay_per_use_price
  end
  # rubocop:enable Metrics/AbcSize, Metrics/PerceivedComplexity
end
