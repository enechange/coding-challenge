class Cost
  include ActiveModel::Model
  # include YamlLoader

  attr_accessor :contract_ampere, :usage

  validates :contract_ampere,   presence: true,
                                inclusion: { in: %w(10 15 20 30 40 50 60) }

  validates :usage,             presence: true

  def calculate
    rates = YAML.load_file(Rails.root.join('config', 'rates.yml'))
    costs = []

    rates.each do |key, values|
      basic_rate = values['basic_rates'][contract_ampere.to_i]
      next unless basic_rate

      usage_total_cost = 0
      remaining_usage = usage.to_i

      values['usage_rates'].each do |rate_info|
        min, max = rate_info['range'].map { |value| value == "inf" ? Float::INFINITY : value }
        difference =  max - min + 1
        if remaining_usage >= difference
          usage_total_cost += rate_info['rate'] * difference
          remaining_usage -= difference
        else
          usage_total_cost += rate_info['rate'] * remaining_usage
          remaining_usage -= remaining_usage
          break
        end
      end
      total_cost = basic_rate + usage_total_cost

      costs << { provider_name: key,
                  plan_name: values['plan_name'],
                  price: total_cost
                }
    end
    costs
  end
end
