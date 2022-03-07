FactoryBot.define do

  factory :commodity_charge do
    trait :dataA do
      id {1}
      plan_id {1}
      min_amount {1}
      max_amount {120}
      unit_price {19.88}
    end

    trait :dataB do
      id {2}
      plan_id {1}
      min_amount {121}
      max_amount {300}
      unit_price {26.48}
    end

    trait :dataC do
      id {3}
      plan_id {1}
      min_amount {301}
      max_amount {999999999}
      unit_price {30.57}
    end

    factory :dataD do
      id {4}
      plan_id {2}
      min_amount {1}
      max_amount {999999999}
      unit_price {26.40}
    end
  end
end