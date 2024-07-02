require 'yaml'

class BillingPlan
  include ActiveModel::Model

  attr_accessor :provider_name, :plan_name, :categories, :prices

  validates :provider_name, presence: true
  validates :plan_name, presence: true
  validates :categories, length: { minimum: 1 }
  validates :prices, length: { minimum: 1 }

  validate :validate_prices_sorted_by_threshold

  VALID_AMPERAGES = [10, 15, 20, 30, 40, 50, 60].freeze

  class InvalidCategoryError < StandardError; end
  class InvalidPriceError < StandardError; end
  class InvalidBillingPlanError < StandardError; end

  class NoCategoryError < StandardError; end

  def initialize(provider_name: '', plan_name: '', categories: [], prices: [])
    @provider_name = provider_name
    @plan_name = plan_name

    initialize_categories(categories:)
    initialize_prices(prices:)
  end

  def initialize_categories(categories: [])
    @categories = categories.map do |c|
      Category
        .new(amperage: c['amperage'], base_charge: c['base_charge'])
        .tap { |category| raise InvalidCategoryError, category.to_json unless category.valid? }
    end
  end

  def initialize_prices(prices: [])
    @prices = prices.map do |p|
      Price
        .new(
          threshold: p['threshold'],
          price_per_kwh: p['price_per_kwh']
        )
        .tap { |price| raise InvalidPriceError, price.to_json unless price.valid? }
    end
  end

  def calculate(amperage, used_kwh) # rubocop:disable Metrics/MethodLength
    charge = 0
    charged_kwh = 0

    prices.each do |price|
      charged =
        if price.threshold.present? && used_kwh > price.threshold
          # 上の料金段階があり、その計算が必要な場合
          price.threshold - charged_kwh
        else
          # 上の料金段階がない場合、もしくは使用量が現在の料金段階に納まる場合
          used_kwh - charged_kwh
        end

      charged_kwh += charged
      charge += price.price_per_kwh * charged

      break if charged_kwh == used_kwh
    end

    charge + base_charge_for(amperage)
  end

  def base_charge_for(amperage)
    category = categories.find { |c| c.amperage == amperage }

    raise NoCategoryError, "No category for amperage: #{amperage}" if category.blank?

    category&.base_charge
  end

  # 料金段階が閾値ごとに昇順で設定されていることを検証する
  def validate_prices_sorted_by_threshold
    return if prices.map { |p| p.threshold || Float::INFINITY }.each_cons(2).all? { |a, b| a < b }

    errors.add(:prices, "must be sorted by threshold")
  end

  class << self
    def all
      @@plans
    end

    def load!
      Rails.logger.debug { "loading plans: #{data_yaml_path}" }

      data = YAML.load_file(data_yaml_path)
      data.map do |p|
        BillingPlan
          .new(provider_name: p['provider_name'],
               plan_name: p['plan_name'],
               categories: p['categories'],
               prices: p['prices'])
          .tap { |bp| raise InvalidBillingPlanError, bp.to_json unless bp.valid? }
      end
    end

    def data_yaml_path
      Rails.root.join('data.yaml')
    end
  end

  @@plans ||= load! # rubocop:disable Style/ClassVars
end
