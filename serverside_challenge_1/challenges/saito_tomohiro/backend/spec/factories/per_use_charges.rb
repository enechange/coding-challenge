FactoryBot.define do
  factory :per_use_charge do
    plan_id { 1 }

    trait :per_use_charge1 do
      id { 1 }
      min_usage { 0 }
      max_usage { 120 }
      per_use_charge { 19.88 }
    end

    trait :per_use_charge2 do
      id { 2 }
      min_usage { 120 }
      max_usage { 300 }
      per_use_charge { 26.48 }
    end

    trait :per_use_charge3 do
      id { 3 }
      min_usage { 300 }
      max_usage { nil }
      per_use_charge { 30.57 }
    end
  end
end
