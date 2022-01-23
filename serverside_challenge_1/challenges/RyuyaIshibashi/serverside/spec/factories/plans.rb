FactoryBot.define do
  factory :plan do
    after(:build) do |plan|
      plan.company = FactoryBot.create(:company)
    end
    name { "foobar" }
  end
end
