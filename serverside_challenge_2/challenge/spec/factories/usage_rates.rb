FactoryBot.define do
  factory :usage_rate do
    plan
    min_kwh { 0 }
    max_kwh { 100 }
    price_per_kwh { 10 }
  end
end
