# frozen_string_literal: true

FactoryBot.define do
  factory :ampere_based_rate do
    association :plan
    sequence(:ampere) { |n| [10, 15, 20, 30, 40, 50, 60][n % 7] }
    rate { '858.00' }
  end
end
