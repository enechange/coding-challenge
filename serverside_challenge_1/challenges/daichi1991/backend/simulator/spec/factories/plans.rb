FactoryBot.define do
  factory :plan do
    trait :従量電灯B do
      id {1}
      plan {'従量電灯B'}
      company {'東京電力エナジーパートナー'}
    end

    trait :おうちプラン do
      id {2}
      plan {'おうちプラン'}
      company {'Loopでんき'}
    end

    trait :ずっとも電気1 do
      id {3}
      plan {'ずっとも電気1'}
      company {'東京ガス株式会社'}
    end

    trait :従量電灯Bたっぷりプラン do
      id {4}
      plan {'従量電灯B たっぷりプラン'}
      company {'JXTGでんき'}
    end

  end
end