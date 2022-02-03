FactoryBot.define do
  factory :plan do
    after(:build) do |plan|
      plan.company = FactoryBot.create(:company)
    end
    name { "foobar_plan" }
  end

  factory :plan_itself, :class => 'Plan'  do
    name { "foobar_plan" }
  end
end
