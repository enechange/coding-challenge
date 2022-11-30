require 'test_helper'

class PlanControllerTest < ActionDispatch::IntegrationTest

  test 'compare' do
    # valid query params
    get '/plan/compare?ampere=10&amount=100'
    assert_response 200
    res = JSON.parse(response.body)
    assert res['errors'].nil?

    # empty ampere
    get '/plan/compare?ampere=&amount=100'
    assert_response 400
    res = JSON.parse(response.body)
    assert res['errors']['ampere'].size > 0

    # invalid ampere
    get '/plan/compare?ampere=1&amount=100'
    assert_response 400
    res = JSON.parse(response.body)
    assert res['errors']['ampere'].size > 0

    # empty amount
    get '/plan/compare?ampere=10&amount='
    assert_response 400
    res = JSON.parse(response.body)
    assert res['errors']['amount'].size > 0

    # zero amount
    get '/plan/compare?ampere=10&amount=0'
    assert_response 200
    res = JSON.parse(response.body)
    assert res['errors'].nil?

    # negative amount
    get '/plan/compare?ampere=10&amount=-10'
    assert_response 400
    res = JSON.parse(response.body)
    assert res['errors']['amount'].size > 0

  end

end
