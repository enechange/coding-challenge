FactoryBot.define do
  factory :basic_rate do
    plan
    ampere { 30 }
    price { 1000 }
  end
end
