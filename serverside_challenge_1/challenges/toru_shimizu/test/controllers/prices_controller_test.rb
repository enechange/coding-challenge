# frozen_string_literal: true

require 'test_helper'

class PricesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get prices_index_url
    assert_response :success
  end
end
