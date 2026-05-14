# frozen_string_literal: true

FactoryBot.define do
  factory :usage_based_rate do
    association :plan
    sequence(:kilowatt_hour_low)  { |n| (n - 1) * 100 }
    sequence(:kilowatt_hour_high) { |n| n * 100 }
    rate { '19.88' }
  end
end
