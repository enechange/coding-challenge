# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_plan_usage_fee do
    min_usage { 0 }
    fee { '19.88' }
    electricity_plan { nil }
  end
end
