# frozen_string_literal: true

# == Schema Information
#
# Table name: providers
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  provider_type :string           not null
#  state         :integer          default("active"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_providers_on_provider_type  (provider_type) UNIQUE
#
FactoryBot.define do
  factory :provider do
    name          { "Provider Name" }
    provider_type { "provider" }

    trait :with_inactive do
      state { :inactive }
    end

    trait :with_plans do
      transient do
        plans_count { 1 }
      end

      after(:create) do |provider, evaluator|
        create_list(:plan, evaluator.plans_count, provider: provider)
      end
    end
  end
end
