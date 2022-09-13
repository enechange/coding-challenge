require 'yaml'

data = open("#{Rails.root}/db/data.yaml", 'r') { |f| YAML.load(f) }
data['providers'].each do |provider_data|

  puts provider_data
  provider = Provider.create(name: provider_data['name'])
  provider_data['plans'].each do |plan_data|

    plan = Plan.create(provider: provider, name: plan_data['name'])
    plan_data['basic_charges'].each do |charge_data|
      charge_data['plan'] = plan
      BasicCharge.create(charge_data)
    end

    plan_data['pay_as_you_go_fees'].each do |fee_data|
      fee_data['plan'] = plan
      PayAsYouGoFee.create(fee_data)
    end
  end
end
