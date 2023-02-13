FactoryBot.define do
  factory :commodity_charge do
    kwh_from { 0 }
    kwh_to { 120 }
    charge { 19.88 }
  end
end
