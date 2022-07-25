ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
  
  # 電力会社名を元に,APIのレスポンスから指定のプランを取得する
  def plan_from_response_body(provider_name, body)
    res = JSON.parse(body)
    plans = res["data"].select{|item| item["provider_name"] == provider_name }
    plans.shift
  end
end
