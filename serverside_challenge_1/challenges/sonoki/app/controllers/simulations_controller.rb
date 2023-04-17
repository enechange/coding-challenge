class SimulationsController < ActionController::Base
  before_action :contract_ampere_options
  require 'net/http'

  def input
  end

  def output
    contract_ampere = params[:contract_ampere]
    usage = params[:usage]

    if usage == "0"
      render :input
    else
      uri = URI("#{ENV['API_URI']}/api/v1/costs/calculate_rate")
      uri.query = URI.encode_www_form({ contract_ampere: contract_ampere, usage: usage })
      request = Net::HTTP::Get.new(uri)
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end
      data = JSON.parse(response.body)
      @results = data
      if @results.empty?
        render :input
      end
    end
  end

  private

  def contract_ampere_options
    @options = [10, 15, 20, 30, 40, 50, 60].freeze
  end
end
