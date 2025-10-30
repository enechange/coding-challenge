# frozen_string_literal: true

class ElectricityChargeCalculator
  class InvalidInputError < StandardError; end
  class InvalidUsageError < StandardError; end
  class InvalidAmpereError < StandardError; end

  INCLUSIVE_RANGE_OFFSET = 1
  TARGET_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze

  class << self
    def execute!(plan:, ampere:, usage:)
      raise ArgumentError, I18n.t('electricity_charge_calculator.errors.plan_required') if plan.nil?

      numeric_ampere = convert_to_numeric!(ampere)
      numeric_usage = convert_to_numeric!(usage)
      validate_input!(numeric_ampere, numeric_usage)
      calculate_total_price(plan, numeric_ampere, numeric_usage)
    end

    private

    def convert_to_numeric!(value)
      Integer(value)
    rescue ArgumentError, TypeError
      raise InvalidInputError, I18n.t('electricity_charge_calculator.errors.invalid_input')
    end

    def validate_input!(ampere, usage)
      raise InvalidUsageError, I18n.t('electricity_charge_calculator.errors.invalid_usage') if usage.negative?

      if TARGET_AMPERES.exclude?(ampere)
        raise InvalidAmpereError,
          I18n.t(
            'electricity_charge_calculator.errors.invalid_ampere',
            target_amperes: TARGET_AMPERES.map { |ampere| "#{ampere}A" }.join(', '),
          )
      end
    end

    def calculate_total_price(plan, ampere, usage)
      basic_charge = plan.basic_charges.find_by(ampere: ampere)
      return if basic_charge.nil?

      usage_amount = calculate_usage_amount(plan, usage)
      return if usage_amount.nil?

      basic_amount = basic_charge.amount
      (basic_amount + usage_amount).floor
    end

    def calculate_usage_amount(plan, usage)
      usage_charges = plan.usage_charges.for_usage(usage)
      return if usage_charges.blank?

      usage_charges.sum do |usage_charge|
        from_kwh = usage_charge.from_kwh
        to_kwh = usage_charge.to_kwh || Float::INFINITY
        usage_in_tier = [usage, to_kwh].min
        chargeable_kwh = calculate_chargeable_kwh_in_tier(from_kwh, usage_in_tier)

        chargeable_kwh * usage_charge.unit_price
      end
    end

    def calculate_chargeable_kwh_in_tier(from_kwh, usage_in_tier)
      from_kwh.zero? ? usage_in_tier : (usage_in_tier - from_kwh + INCLUSIVE_RANGE_OFFSET)
    end
  end
end
