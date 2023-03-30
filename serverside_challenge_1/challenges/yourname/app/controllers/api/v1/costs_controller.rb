class Api::V1::CostsController < ApplicationController
  require 'yaml'

  def index
    yaml_path = "config/costs.yml" # 例: 'config/my_yaml.yml'
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

  # def culculate

  # end
end
