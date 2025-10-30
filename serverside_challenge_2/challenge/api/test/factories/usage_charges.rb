# frozen_string_literal: true

# == Schema Information
#
# Table name: usage_charges
#
#  id         :bigint           not null, primary key
#  from_kwh   :integer          not null
#  to_kwh     :integer
#  unit_price :decimal(8, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_id    :bigint           not null
#
# Indexes
#
#  index_usage_charges_on_plan_id               (plan_id)
#  index_usage_charges_on_plan_id_and_from_kwh  (plan_id,from_kwh) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#
FactoryBot.define do
  factory :usage_charge do
    plan { create(:plan) }
    from_kwh { 0 }
    to_kwh { 100 }
    unit_price { 10.00 }
  end
end
