class Api::V1::CostsController < ApplicationController
  include YamlLoader

  def index
    render json: {
      status: 'SUCCESS',
      message: '電力会社とコスト一覧の取得に成功しました',
      data: yaml_data
    }, status: 200
  end

  def calculate_rate
    @cost_query = Cost.new(query_params)
    if @cost_query.valid?
      @costs = @cost_query.calculate
      render json: @costs, status: 200
    else
      render json: { error: 'Invalid input: contract_ampere and usage are required' }, status: 400
    end
  end

  private

  def query_params
    params.permit(:contract_ampere, :usage).to_h.with_indifferent_access
  end

end
