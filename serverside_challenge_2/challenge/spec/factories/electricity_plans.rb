# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_plan do
    name { '従量電灯B' }
    electricity_provider { nil }
  end
end
