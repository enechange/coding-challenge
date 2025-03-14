# frozen_string_literal: true

require 'yaml'

def create_provider_and_plans(provider_name, plans_data)
  provider = Provider.find_or_create_by!(name: provider_name)

  plans_data.each do |plan_data|
    plan = Plan.find_or_create_by!(provider: provider, name: plan_data['name'])

    create_basic_rates(plan, plan_data['basic_rates'])
    create_usage_rates(plan, plan_data['usage_rates'])
  end
end

def create_basic_rates(plan, rates)
  rates.each do |rate_data|
    ElectricityChargesBasicRate.find_or_create_by!(
      plan: plan,
      ampere: rate_data['ampere']
    ) do |rate|
      rate.basic_rate = rate_data['basic_rate']
    end
  end
end

def create_usage_rates(plan, rates)
  rates.each do |rate_data|
    ElectricityChargesUsageRate.find_or_create_by!(
      plan: plan,
      min_usage: rate_data['min_usage'],
      max_usage: rate_data['max_usage']
    ) do |rate|
      rate.unit_rate = rate_data['unit_rate']
    end
  end
end

seed_data = YAML.load_file(Rails.root.join('db/seeds/provider_plan_rates.yml'))
seed_data['providers'].each do |provider_data|
  create_provider_and_plans(provider_data['name'], provider_data['plans'])
end

puts '各電力会社と、そのプラン作成が完了しました'
