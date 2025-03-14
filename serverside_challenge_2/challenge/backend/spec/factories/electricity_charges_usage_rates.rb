# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_charges_usage_rate do
    association :plan
    min_usage { 0 }
    max_usage { 120 }
    unit_rate { BigDecimal('10.00') }

    trait :low_usage do
      min_usage { 0 }
      max_usage { 120 }
      unit_rate { 20.0 }
    end

    trait :mid_usage do
      min_usage { 121 }
      max_usage { 300 }
      unit_rate { 25.0 }
    end

    trait :high_usage do
      min_usage { 301 }
      max_usage { nil }
      unit_rate { 30.0 }
    end
  end
end
