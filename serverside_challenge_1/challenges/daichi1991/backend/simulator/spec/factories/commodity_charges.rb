FactoryBot.define do
  factory :commodity_charge do
    trait :commodityChargeA1 do
      id { 1 }
      plan_code { 'PL000001' }
      min_amount { 1 }
      max_amount { 120 }
      unit_price { 19.88 }
    end
    trait :commodityChargeA2 do
      id { 2 }
      plan_code { 'PL000001' }
      min_amount { 121 }
      max_amount { 300 }
      unit_price { 26.48 }
    end
    trait :commodityChargeA3 do
      id { 3 }
      plan_code { 'PL000001' }
      min_amount { 301 }
      max_amount { 999999999 }
      unit_price { 30.57 }
    end
    trait :commodityChargeB1 do
      id { 4 }
      plan_code { 'PL000002' }
      min_amount { 1 }
      max_amount { 999999999 }
      unit_price { 26.40 }
    end
  end
end
