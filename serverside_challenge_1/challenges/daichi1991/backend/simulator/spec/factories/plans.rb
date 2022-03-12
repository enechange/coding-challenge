FactoryBot.define do
  factory :plan do
    trait :A do
      id { 1 }
      plan { '従量電灯B' }
      provider_name { '東京電力エナジーパートナー' }
    end

    trait :B do
      id { 2 }
      plan { 'おうちプラン' }
      provider_name { 'Loopでんき' }
    end

    trait :C do
      id { 3 }
      plan { 'ずっとも電気1' }
      provider_name { '東京ガス株式会社' }
    end

    trait :D do
      id { 4 }
      plan { '従量電灯B たっぷりプラン' }
      provider_name { 'JXTGでんき' }
    end
  end
end
