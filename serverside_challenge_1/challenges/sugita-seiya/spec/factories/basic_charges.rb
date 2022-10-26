FactoryBot.define do
  factory :basic_charge do
    contract_amperage { 10 }
    charge_unit_price { 100 }
  end
end
