# frozen_string_literal: true

ActiveRecord::Base.transaction do
  YAML.safe_load_file(Rails.root.join('db/data/providers.yml')).each do |attrs|
    Provider.find_or_create_by!(name: attrs.fetch('name'))
  end

  YAML.safe_load_file(Rails.root.join('db/data/plans.yml')).each do |entry|
    provider = Provider.find_by!(name: entry.fetch('provider_name'))
    entry.fetch('plans').each do |attrs|
      plan = Plan.find_or_initialize_by(slug: attrs.fetch('slug'))
      plan.update!(provider: provider, name: attrs.fetch('name'))
    end
  end

  YAML.safe_load_file(Rails.root.join('db/data/ampere_based_rates.yml')).each do |entry|
    plan = Plan.find_by!(slug: entry.fetch('slug'))
    entry.fetch('rates').each do |attrs|
      record = AmpereBasedRate.find_or_initialize_by(plan: plan, ampere: attrs.fetch('ampere'))
      record.update!(rate: attrs.fetch('rate'))
    end
  end

  YAML.safe_load_file(Rails.root.join('db/data/usage_based_rates.yml')).each do |entry|
    plan = Plan.find_by!(slug: entry.fetch('slug'))
    entry.fetch('rates').each do |attrs|
      low = attrs.fetch('kilowatt_hour_low')
      high = attrs.fetch('kilowatt_hour_high') || ElectricityBillConstants::MAX_KWH
      record = UsageBasedRate.find_or_initialize_by(
        plan: plan,
        kilowatt_hour_low: low,
        kilowatt_hour_high: high
      )
      record.update!(rate: attrs.fetch('rate'))
    end
  end
end
