# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  ampere     :integer          not null
#  charge     :decimal(10, 2)   not null
#  state      :integer          default("active"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id  (plan_id)
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id) ON DELETE => cascade
#
FactoryBot.define do
  factory :basic_charge do
    ampere      { [ 10, 15, 20, 30, 40, 50, 60 ].sample }
    charge      { 286.00 }
    association :plan

    trait :with_inactive do
      state { :inactive }
    end
  end
end
