FactoryBot.define do
  factory :electricity_fee do
    plan
    classification_min {}
    classification_max {}
    unit { 1 }
    price {}
  end
end
