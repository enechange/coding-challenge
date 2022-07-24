require "test_helper"

class Api::V1::PlansControllerTest < ActionDispatch::IntegrationTest

  test "APIのレスポンスがかえってくること" do
    get api_v1_plans_index_url
    assert_response :success
  end
end
