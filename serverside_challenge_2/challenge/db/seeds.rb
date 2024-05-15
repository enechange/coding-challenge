# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

provider_plans = [
  {
    provider_name: '東京電力エナジーパートナー',
    plans: [
      {
        name: '従量電灯B',
        basic_rates: [
          { amperage: 10, rate: 286.00 },
          { amperage: 15, rate: 429.00 },
          { amperage: 20, rate: 572.00 },
          { amperage: 30, rate: 858.00 },
          { amperage: 40, rate: 1144.00 },
          { amperage: 50, rate: 1430.00 },
          { amperage: 60, rate: 1716.00 }
        ],
        usage_rates: [
          { limit_kwh: 120, rate: 19.88 },
          { limit_kwh: 300, rate: 26.48 },
          { limit_kwh: nil, rate: 30.57 }
        ]
      },
      {
        name: 'スタンダードS',
        basic_rates: [
          { amperage: 10, rate: 311.75 }, 
          { amperage: 15, rate: 467.63 },
          { amperage: 20, rate: 623.50 },
          { amperage: 30, rate: 935.25 },
          { amperage: 40, rate: 1247.00 },
          { amperage: 50, rate: 1558.75 },
          { amperage: 60, rate: 1716.00 }
        ],
        usage_rates: [
          { limit_kwh: 120, rate: 29.80 },
          { limit_kwh: 300, rate: 36.40 },
          { limit_kwh: nil, rate: 40.49 }
        ]
      }
    ]
  },
  {
    provider_name: '東京ガス',
    plans: [
      {
        name: 'ずっとも電気1',
        basic_rates: [
          { amperage: 30, rate: 858.00 },
          { amperage: 40, rate: 1144.00 },
          { amperage: 50, rate: 1430.00 },
          { amperage: 60, rate: 1716.00 }
        ],
        usage_rates: [
          { limit_kwh: 140, rate: 23.67 },
          { limit_kwh: 350, rate: 23.88 },
          { limit_kwh: nil, rate: 26.41 }
        ]
      }
    ]
  },
  {
    provider_name: 'Looopでんき',
    plans: [
      {
        name: 'おうちプラン',
        basic_rates: [
          { amperage: 10, rate: 0.00 },
          { amperage: 15, rate: 0.00 },
          { amperage: 20, rate: 0.00 },
          { amperage: 30, rate: 0.00 },
          { amperage: 40, rate: 0.00 },
          { amperage: 50, rate: 0.00 },
          { amperage: 60, rate: 0.00 }
        ],
        usage_rates: [
          { limit_kwh: nil, rate: 28.8 }
        ]
      }
    ]
  }
]

ActiveRecord::Base.transaction do
  provider_plans.each do |provider_plan|
    provider = Provider.create!(name: provider_plan[:provider_name])

    provider_plan[:plans].each do |plan|
      electricity_plan = provider.electricity_plans.create!(name: plan[:name])

      plan[:basic_rates].each do |basic_rate|
        electricity_plan.basic_rates.create!(amperage: basic_rate[:amperage], rate: basic_rate[:rate])
      end

      plan[:usage_rates].each do |usage_rate|
        electricity_plan.usage_rates.create!(limit_kwh: usage_rate[:limit_kwh], rate: usage_rate[:rate])
      end
    end
  end
end
