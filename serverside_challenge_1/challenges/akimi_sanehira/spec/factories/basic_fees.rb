FactoryBot.define do
  factory :basic_fee do
    after(:build) do |basic_fee|
      basic_fee.plan = create(:plan)
    end
    ampere { "99" }
    base_fee { "9.99" }
  end

  factory :basic_fee_itself, :class => 'BasicFee' do
    ampere { "99" }
    base_fee { "9.99" }
  end
end