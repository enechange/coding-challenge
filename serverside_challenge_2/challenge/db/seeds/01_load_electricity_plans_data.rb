require "yaml"

# YAMLファイルの読み込み
data = YAML.load_file(Rails.root.join("db", "data", "electricity_plans.yml"))

data["plans"].each do |plan_data|
  provider = Provider.find_or_create_by!(name: plan_data["provider_name"], provider_type: plan_data["provider_type"])
  plan     = Plan.find_or_create_by!(provider: provider, name: plan_data["plan_name"], plan_type: plan_data["plan_type"])

  # 基本料金の登録
  plan_data["basic_charges"].each do |ampere, charge|
    BasicCharge.find_or_create_by!(plan: plan, ampere: ampere.to_i, charge: charge.to_f)
  end

  # 従量料金の登録
  plan_data["usage_charges"].each do |charge_data|
    UsageCharge.find_or_create_by!(
      plan: plan,
      lower_limit: charge_data["lower_limit"],
      upper_limit: charge_data["upper_limit"],
      charge: charge_data["charge"]
    )
  end
end
