FactoryBot.define do

  factory :従量電灯B, class: Plan do
    plan '従量電灯B'
    company '東京電力エナジーパートナー'
  end

  factory :おうちプラン, class: Plan do
    plan 'おうちプラン'
    company 'Loopでんき'
  end

  factory :ずっとも電気1, class: Plan do
    plan 'ずっとも電気1'
    company '東京ガス株式会社'
  end

  factory :従量電灯Bたっぷりプラン, class: Plan do
    plan '従量電灯B たっぷりプラン'
    company 'JXTGでんき'
  end

end