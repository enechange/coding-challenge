FactoryBot.define do
  factory :plan  do
    association :provider
  end

  factory :ranged_fee_plan, class: Plan  do
    association :provider
    name { 'RangedFeePlan' }
    pay_as_you_go_fees {
      ['to120', '120to300', '300to600', 'over600'].map do |name|
        FactoryBot.build(name.to_sym)
      end
    }
  end

  factory :single_fee_plan, class: Plan do
    association :provider
    name { 'SingleFeePlan' }
    pay_as_you_go_fees { [FactoryBot.build(:single_fee)] }
  end
end
