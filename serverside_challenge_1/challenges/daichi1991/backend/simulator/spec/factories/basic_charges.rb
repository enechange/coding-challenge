FactoryBot.define do
  factory :basic_charge do
    trait :basicChargeA1 do
      id { 1 }
      plan_code { 'PL000001' }
      ampere { 10 }
      charge { 286.00 }
    end
    trait :basicChargeB1 do
      id { 2 }
      plan_code { 'PL000002' }
      ampere { 10 }
      charge { 0.00 }
    end
  end
end
