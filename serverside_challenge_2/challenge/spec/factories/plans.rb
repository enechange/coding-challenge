# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  plan_type   :string           not null
#  state       :integer          default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  provider_id :bigint           not null
#
# Indexes
#
#  index_plans_on_provider_id                (provider_id)
#  index_plans_on_provider_id_and_plan_type  (provider_id,plan_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (provider_id => providers.id) ON DELETE => cascade
#
FactoryBot.define do
  factory :plan do
    name { "Basic Plan" }
    plan_type { "plan" }
    association :provider

    trait :with_inactive do
      state { :inactive }
    end

    trait :with_charges do
      transient do
        basic_charges_count { 1 }
        usage_charges_count { 1 }
      end

      after(:create) do |plan, evaluator|
        create_list(:basic_charge, evaluator.basic_charges_count, plan: plan)
        create_list(:usage_charge, evaluator.usage_charges_count, plan: plan)
      end
    end
  end
end
