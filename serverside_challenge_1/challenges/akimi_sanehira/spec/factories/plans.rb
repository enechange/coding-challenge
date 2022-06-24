FactoryBot.define do
  factory :plan do
    after(:build) do |plan|
      plan.provider = create(:provider)
    end
    id { 1 }
    name { "hoge_plan" }
  end

  factory :plan_itself, :class => 'Plan'  do
    id { 1 }
    name { "hoge_plan" }
  end
end
