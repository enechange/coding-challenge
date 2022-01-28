FactoryBot.define do
  factory :usage_charge do
    after(:build) do |usage_charge|
      usage_charge.plan = FactoryBot.create(:plan)
    end
    from { "9.99" }
    to { "9.99" }
    unit_price { "9.99" }
  end

  factory :usage_charge_2, :class => 'UsageCharge'  do
    from { "9.99" }
    to { "9.99" }
    unit_price { "9.99" }    
  end
end
