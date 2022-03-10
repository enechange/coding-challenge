FactoryBot.define do
  factory :plan do
    after(:build) do |plan|
      plan.company = FactoryBot.create(:company)
    end
    id { 1 }
    name { "foobar_plan" }
  end

  factory :plan_itself, :class => 'Plan'  do
    id { 1 }
    name { "foobar_plan" }
  end
end
