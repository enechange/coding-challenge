FactoryBot.define do
  factory :provider, class: ElectricPowerProvider do
    name { 'first_provider_name' }
  end
  factory :provider_second, class: ElectricPowerProvider do
    name { 'second_provider_name' }
  end
end
