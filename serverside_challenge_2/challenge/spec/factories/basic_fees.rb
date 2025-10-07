FactoryBot.define do
  factory :basic_fee do
    plan
    sequence(:code) { |n| "basic_fee_code_#{n}" }
    ampere { rand(10..60) }
    fee { rand(500.00..2000.00).round(2) }
  end
end

# == Schema Information
#
# Table name: basic_fees
#
#  id                        :bigint           not null, primary key
#  ampere(契約アンペア数(A)) :integer          not null
#  code                      :string           not null
#  fee(基本料金(円))         :decimal(10, 2)   not null
#  plan_code                 :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
# Indexes
#
#  index_basic_fees_on_ampere                (ampere)
#  index_basic_fees_on_code                  (code) UNIQUE
#  index_basic_fees_on_plan_code_and_ampere  (plan_code,ampere) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (plan_code => plans.code)
#
