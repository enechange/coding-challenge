# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_plan do
    sequence(:name) { |n| "ElectricityPlan#{n}" }
  end
end
