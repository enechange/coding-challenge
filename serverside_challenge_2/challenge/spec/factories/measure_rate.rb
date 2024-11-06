FactoryBot.define do
  factory :measured_rate do
    electricity_usage_min { 0 }
    electricity_usage_max { 100 }
    price { 1.01 }
  end
end
