# frozen_string_literal: true

class ElectricityBillSimulator
  include ElectricityBillConstants

  def self.call(ampere:, kwh:)
    new(ampere: ampere, kwh: kwh).call
  end

  def initialize(ampere:, kwh:)
    @ampere = parse_integer!(ampere, :ampere)
    @kwh = parse_integer!(kwh, :kwh)

    validate!
  end

  def call
    Plan.includes(:provider, :ampere_based_rates, :usage_based_rates)
        .filter_map { |plan| pair_with_price(plan) }
        .sort_by { |plan, price| [price, plan.provider.name, plan.name] }
        .map { |plan, price| { provider_name: plan.provider.name, plan_name: plan.name, price: price } }
  end

  private

  def parse_integer!(value, name)
    raise ArgumentError, "#{name} must be an integer (got #{value.inspect})" if value.is_a?(Float)

    Integer(value)
  end

  def validate!
    unless VALID_AMPERES.include?(@ampere)
      raise ArgumentError, "ampere must be one of #{VALID_AMPERES} (got #{@ampere})"
    end
    raise ArgumentError, "kwh must be between 0 and #{MAX_KWH} (got #{@kwh})" unless (0..MAX_KWH).cover?(@kwh)
  end

  # アンペア非対応プランは nil を返し、filter_map で除外する
  def pair_with_price(plan)
    base = plan.base_price_for(@ampere)
    return nil if base.nil?

    [plan, (base + usage_price(plan)).floor.to_i]
  end

  def usage_price(plan)
    plan.usage_based_rates.sum(BigDecimal(0)) do |usage_rate|
      usage_rate.rate * billable_kwh_for(usage_rate)
    end
  end

  def billable_kwh_for(usage_rate)
    upper = [@kwh, usage_rate.kilowatt_hour_high].min

    [upper - usage_rate.kilowatt_hour_low, 0].max
  end
end
