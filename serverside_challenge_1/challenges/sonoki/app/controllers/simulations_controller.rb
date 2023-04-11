class SimulationsController < ActionController::Base

  require 'net/http'

  def input
  end

  def output
    contract_ampere = params[:contract_ampere]
    usage = params[:usage]

    uri = URI("#{ENV['API_URI']}/api/v1/costs/calculate_rate")
    uri.query = URI.encode_www_form({ contract_ampere: contract_ampere, usage: usage })
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    data = JSON.parse(response.body)
    @results = data
    render "output"
  end
end
