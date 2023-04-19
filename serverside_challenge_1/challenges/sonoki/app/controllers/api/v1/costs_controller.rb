class Api::V1::CostsController < ApplicationController
  require 'yaml'

  def index
    yaml_data = YAML.load_file(yaml_path)
    render json: {
      status: 'SUCCESS',
      message: '電力会社とコスト一覧の取得に成功しました',
      data: yaml_data
    }, status: 200
  end

  def calculate_rate
    contract_ampere = params[:contract_ampere].to_i
    usage = params[:usage].to_i
    rates = YAML.load_file(yaml_path)

    if contract_ampere.zero? || usage.zero?
      render json: { error: 'Invalid input: contract_ampere and usage are required' }, status: 400
    else
      costs = []
      rates.each do |key, values|
        basic_rate = values['basic_rates'][contract_ampere]
        next unless basic_rate

        usage_total_cost = 0
        remaining_usage = usage

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
      render json: costs, status: 200
    end
  end

  private

  def yaml_path
    @yaml_path ||= Rails.root.join('config', 'rates.yml')
  end

end
