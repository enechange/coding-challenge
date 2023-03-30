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
      basic_rate = rates['CompanyA']['basic_rates'][contract_ampere]
      usage_rate = rates['CompanyA']['usage_rate']
      total_cost = basic_rate + (usage_rate * usage)

      costs = []
      rates.keys.each do |key|
        costs << { 電力会社: key,
                    料金: total_cost
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
