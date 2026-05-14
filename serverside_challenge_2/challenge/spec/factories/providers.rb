# frozen_string_literal: true

FactoryBot.define do
  factory :provider do
    sequence(:name) { |n| "電力会社#{n}" }
  end
end
