FactoryBot.define do
  factory :basic_charge do
    plan
    ampere {}
    unit { 1 }
    price {}
  end
end
