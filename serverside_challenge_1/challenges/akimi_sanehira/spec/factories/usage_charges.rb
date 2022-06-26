FactoryBot.define do
  factory :usage_charge do
    plan_id { 1 }
    min_usage { 0 }
    max_usage { 120 }
    unit_usage_fee { 19.88 }
  end
end
