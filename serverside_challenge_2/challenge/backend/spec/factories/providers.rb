# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    sequence(:name) { |n| "プロバイダー#{n}" }
  end
end
