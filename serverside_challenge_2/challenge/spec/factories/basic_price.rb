FactoryBot.define do
  factory :basic_price do
    amperage { BasicPrice::AMPERAGE_LIST[0] }
    price { 1.01 }
  end
end
