FactoryBot.define do
  factory :usage_charge do
    after(:build) do |usage_charge|
      usage_charge.plan = FactoryBot.create(:plan)
    end
    min_usage { "120" }
    max_usage { "240" }
    unit_usage_fee { "9.99" }
  end

  factory :usage_charge_itself, :class => 'UsageCharge'  do
    min_usage { "120" }
    max_usage { "240" }
    unit_usage_fee { "9.99" }
  end
end