FactoryBot.define do
  factory :basic_charge do
    trait :data1 do
      id { 1 }
      plan_id { 1 }
      ampere { 20 }
      charge { '572.00' }
    end

    trait :data2 do
      id { 2 }
      plan_id { 1 }
      ampere { 30 }
      charge { '858.00' }
    end
  end
end
