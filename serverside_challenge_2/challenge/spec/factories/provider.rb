# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    sequence(:name) { |n| "Provider#{n}" }
  end
end
