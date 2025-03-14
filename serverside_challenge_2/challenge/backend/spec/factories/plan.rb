# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    association :provider
    sequence(:name) { |n| "プラン#{n}" }
  end
end
