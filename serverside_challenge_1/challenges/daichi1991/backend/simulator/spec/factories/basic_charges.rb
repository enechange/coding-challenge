FactoryBot.define do
  factory :basic_charge do
    trait :data1 do
      id {1}
      plan_id {1}
      ampere {20}
      charge {'572.00'}
    end

    trait :data2 do
      id {2}
      plan_id {1}
      ampere {30}
      charge {'858.00'}
    end

    trait :data3 do
      id {3}
      plan_id {2}
      ampere {20}
      charge {'0.00'}
    end

    trait :data4 do
      id {4}
      plan_id {2}
      ampere {30}
      charge {'0.00'}
    end

    trait :data5 do
      id {5}
      plan_id {3}
      ampere {30}
      charge {'858.00'}
    end

    factory :data6 do
      id {6}
      plan_id {4}
      ampere {30}
      charge {'858.00'}
    end
  end
end