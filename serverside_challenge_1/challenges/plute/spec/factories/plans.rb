FactoryBot.define do
  factory :plan do
    id { 1 }
    provider_id { 1 }
    name { "plan_name" }
    # after(:build) do |plan|
    #   plan.provider = FactoryBot.create(:provider)
    # end
  end
end
