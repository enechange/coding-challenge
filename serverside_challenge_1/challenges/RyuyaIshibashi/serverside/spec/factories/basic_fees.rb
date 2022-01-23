FactoryBot.define do
  factory :basic_fee do
    after(:build) do |basic_fee|
      basic_fee.plan = FactoryBot.create(:plan)
    end
    ampare { "9.99" }
    fee { "9.99" }
  end
end
