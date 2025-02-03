require "test_helper"

class SimulationsControllerTest < ActionDispatch::IntegrationTest
  test "should get calculate" do
    get simulations_calculate_url
    assert_response :success
  end
end
