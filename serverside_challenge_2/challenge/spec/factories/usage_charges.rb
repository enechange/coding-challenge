# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id          :bigint           not null, primary key
#  charge      :decimal(10, 2)   not null
#  lower_limit :integer          not null
#  state       :integer          default("active"), not null
#  upper_limit :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  plan_id     :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
#
FactoryBot.define do
  factory :usage_charge do
    charge      { 19.88 }
    lower_limit { 0 }
    upper_limit { 120 }
    association :plan

    trait :with_inactive do
      state { :inactive }
    end

    trait :with_upper_limit_null do
      upper_limit { nil }
    end
  end
end
