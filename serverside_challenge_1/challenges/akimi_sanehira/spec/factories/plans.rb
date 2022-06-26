FactoryBot.define do
  factory :plan do
    after(:build) do |plan|
      plan.provider = create(:provider)
    end
    name { "hoge_plan" }
  end

  factory :plan_itself, :class => 'Plan'  do
    name { "hoge_plan" }
  end
end
