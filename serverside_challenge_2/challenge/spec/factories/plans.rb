FactoryBot.define do
  factory :plan do
    provider
    sequence(:code) { |n| "plan_code_#{n}" }
    sequence(:name) { |n| "Plan_#{n}" }
  end
end

# == Schema Information
#
# Table name: plans
#
#  id            :bigint           not null, primary key
#  code          :string           not null
#  name          :string           not null
#  provider_code :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_plans_on_code           (code) UNIQUE
#  index_plans_on_provider_code  (provider_code)
#
# Foreign Keys
#
#  fk_rails_...  (provider_code => providers.code)
#
