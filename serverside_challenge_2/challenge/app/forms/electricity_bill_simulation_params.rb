# frozen_string_literal: true

class ElectricityBillSimulationParams
  include ActiveModel::Model
  include ElectricityBillConstants

  attr_writer :ampere, :kwh

  validates :ampere, presence: true,
                     inclusion: { in: VALID_AMPERES, allow_blank: true }
  validates :kwh, presence: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 0,
                    less_than_or_equal_to: MAX_KWH,
                    allow_blank: true
                  }

  def ampere
    cast_to_integer(@ampere)
  end

  def kwh
    cast_to_integer(@kwh)
  end

  def jsonapi_errors
    errors.map do |error|
      {
        status: '400',
        title: I18n.t('electricity_bill_simulations.errors.title'),
        detail: error.full_message,
        source: { parameter: error.attribute.to_s }
      }
    end
  end

  private

  def cast_to_integer(value)
    return nil if value.nil? || value == ''

    Integer(value.to_s, 10)
  rescue ArgumentError
    value
  end
end
