require "test_helper"

class Api::V1::PlansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_plans_index_url
    assert_response :success
  end
end
