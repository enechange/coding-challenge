FactoryBot.define do
  factory :plan do
    name { "従量電灯B" }
  end

  factory :plan_with_charges, class: Plan do
    name { "従量電灯B" }

    after(:create) do |plan|
      plan.basic_charges = [
        FactoryBot.build(:basic_charge, {
                           ampere: 10,
                           charge: 286.00
                         }),
        FactoryBot.build(:basic_charge, {
                           ampere: 15,
                           charge: 421.2
                         })
      ]
      plan.commodity_charges = [
        FactoryBot.build(:commodity_charge, {
                           kwh_from: 0,
                           kwh_to: 120,
                           charge: 19.88
                         }),
        FactoryBot.build(:commodity_charge, {
                           kwh_from: 120,
                           kwh_to: 300,
                           charge: 26.48
                         }),
        FactoryBot.build(:commodity_charge, {
                           kwh_from: 300,
                           kwh_to: nil,
                           charge: 30.57
                         })
      ]
    end
  end
end
