FactoryBot.define do
  factory :provider do
    sequence(:code) { |n| "provider_code_#{n}" }
    sequence(:name) { |n| "Provider_#{n}" }
  end
end

# == Schema Information
#
# Table name: providers
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_providers_on_code  (code) UNIQUE
#
