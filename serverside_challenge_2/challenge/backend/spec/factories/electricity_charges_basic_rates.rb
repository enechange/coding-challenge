# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_charges_basic_rate do
    association :plan
    ampere { 10 }
    basic_rate { BigDecimal('100.00') }
  end
end
