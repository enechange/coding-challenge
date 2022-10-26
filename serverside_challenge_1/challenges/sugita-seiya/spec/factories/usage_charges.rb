FactoryBot.define do
  factory :usage_charge do
    charge_unit_price { 100 }
    minimum_usage { 0 }
    max_usage { 100 }
  end
end
