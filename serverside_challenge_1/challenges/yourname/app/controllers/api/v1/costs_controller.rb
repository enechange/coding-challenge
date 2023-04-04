class Api::V1::CostsController < ApplicationController
  require 'yaml'

  def index
    if File.exist?(yaml_path)
      yaml_data = YAML.load_file(yaml_path)
      render json: {
        status: 'SUCCESS',
        message: '電力会社とコスト一覧の取得に成功しました',
        data: yaml_data
      }, status: 200
    else
      render json: { error: 'File not found' }, status: 404
    end
  end

  def calculate_rate
    contract_ampere = params[:contract_ampere].to_i
    usage = params[:usage].to_i
    rates = YAML.load_file(yaml_path)
    if contract_ampere && usage
      costs = []
      rates.keys.each do |key|
        basic_rate = rates[key.to_s]['basic_rates'][contract_ampere]
        next unless basic_rate

        usage_total_cost = 0
        remaining_usage = usage

        rates[key.to_s]['usage_rates'].each do |rate_info|
          min, max = rate_info['range'].map { |value| value == "inf" ? Float::INFINITY : value }

          if remaining_usage >= max
            usage_total_cost += rate_info['rate'] * (max - min + 1)
            remaining_usage -= (max - min + 1)
          else
            usage_total_cost += rate_info['rate'] * remaining_usage
            remaining_usage -= remaining_usage
            break
          end
        end
        total_cost = basic_rate + usage_total_cost

        costs << { provider_name: key,
                    plan_name: rates[key.to_s]['plan_name'],
                    price: total_cost
                  }
      end
      render json: costs.to_json, status: 200
    else
      render json: { error: 'Invalid companyname' }, status: 400
    end
  end

  private

  def yaml_path
    Rails.root.join('config', 'rates.yml')
  end
end
