# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_plan_basic_fee do
    ampere { 10 }
    fee { '286.00' }
    electricity_plan { nil }
  end
end
