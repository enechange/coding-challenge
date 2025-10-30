# frozen_string_literal: true

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
FactoryBot.define do
  factory :provider do
    name { Faker::Company.name }
    sequence(:code) { |n| "code_#{n}" }
  end
end
