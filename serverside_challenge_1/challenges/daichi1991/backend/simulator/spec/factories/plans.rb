FactoryBot.define do
  factory :plan do
    trait :planA do
      plan_code { 'PL000001' }
      plan_name { '従量電灯B' }
      provider_code { 'PR000001' }
    end

    trait :planB do
      plan_code { 'PL000002' }
      plan_name { 'おうちプラン' }
      provider_code { 'PR000002' }
    end

    trait :planC do
      plan_code { 'PL000003' }
      plan_name { 'ずっとも電気1' }
      provider_code { 'PR000003' }
    end
  end
end
