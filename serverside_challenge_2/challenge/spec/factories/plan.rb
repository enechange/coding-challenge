FactoryBot.define do
  factory :provider do
    name { "Test Provider" }
  end

  factory :plan do
    name { "Test Plan" }
    provider
  end
end
