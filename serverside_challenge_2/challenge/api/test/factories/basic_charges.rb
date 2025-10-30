# frozen_string_literal: true

# == Schema Information
#
# Table name: basic_charges
#
#  id         :bigint           not null, primary key
#  amount     :decimal(8, 2)    not null
#  ampere     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_basic_charges_on_plan_id             (plan_id)
#  index_basic_charges_on_plan_id_and_ampere  (plan_id,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
FactoryBot.define do
  factory :basic_charge do
    plan { create(:plan) }
    ampere { 10 }
    amount { 1000.00 }
  end
end
