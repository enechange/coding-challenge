# frozen_string_literal: true

FactoryBot.define do
  factory :electricity_rate_simulation, class: ElectricityRateSimulation do
    amperage { 30 }
    usage_kwh { 100 }

    initialize_with { new(amperage, usage_kwh) }
  end
end
