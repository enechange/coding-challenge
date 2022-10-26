FactoryBot.define do
  factory :plan, class: ElectricityRatePlan do
    name { 'first_plan_name' }
  end
  factory :second_plan, class: ElectricityRatePlan do
    name { 'second_plan_name' }
  end
end
