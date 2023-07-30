class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true

  def self.electricity_rate_list(electricity_rate_params)
    validate_electricity_rate_params!(electricity_rate_params)
    electricity_rate_list = []
    Provider.all.each do |provider|
      provider.plans.each do |plan|
        basic_rate = plan.basic_rates.find_by(ampere: electricity_rate_params[:ampere].to_i)
        next if basic_rate.nil?
        pay_per_use_rate = plan.pay_per_use_rates.find_by(
          min_electricity_usage: [nil, ..electricity_rate_params[:electricity_usage].to_i],
          max_electricity_usage: [nil, electricity_rate_params[:electricity_usage].to_i..]
        )
        total_price = basic_rate.price + pay_per_use_rate.unit_price * electricity_rate_params[:electricity_usage].to_i
        electricity_rate_list << {
          provider_name: provider.name,
          plan_name: plan.name,
          price: total_price.floor
        }
      end
    end
    return electricity_rate_list
  end

  private

  def self.validate_electricity_rate_params!(electricity_rate_params)
    raise ActionController::BadRequest, '必要な値がありません' if electricity_rate_params_blank?(electricity_rate_params)
    raise ActionController::BadRequest, '契約アンペア数は10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかから選択してください' if ampere_invalid?(electricity_rate_params)
    raise ActionController::BadRequest, '電力使用量は0以上の整数でご入力ください' if electricity_rate_params[:electricity_usage] !~ /^[0-9]+$/
  end

  def self.electricity_rate_params_blank?(electricity_rate_params)
    electricity_rate_params[:ampere].blank? || electricity_rate_params[:electricity_usage].blank?
  end

  def self.ampere_invalid?(electricity_rate_params)
    ampere_valid_list = [10, 15, 20, 30, 40, 50, 60]
    ampere_valid_list.exclude?(electricity_rate_params[:ampere].to_i)
  end
end
