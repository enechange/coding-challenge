FactoryBot.define do
  factory :provider do
    trait :providerA do
      provider_code { 'PR000001' }
      provider_name { '東京電力エナジーパートナー' }
    end

    trait :providerB do
      provider_code { 'PR000002' }
      provider_name { 'Loopでんき' }
    end

    trait :providerC do
      provider_code { 'PR000003' }
      provider_name { '東京ガス' }
    end
  end
end