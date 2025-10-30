# frozen_string_literal: true

require 'test_helper'

class Api::V1::ElectricityChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = create(:provider, name: 'テスト電気')
    @plan = create(:plan, provider: @provider, name: 'テストプラン')
  end

  def parse_response_body
    JSON.parse(response.body)
  end

  test '#indexは契約アンペア数と使用量を受け取り、プランの料金を返す' do
    create(:basic_charge, plan: @plan)
    create(:usage_charge, plan: @plan)
    expected_price = 1000

    ElectricityChargeCalculator.expects(:execute!).returns(expected_price)

    get api_v1_electricity_charges_path, params: { ampere: 10, usage: 100 }

    assert_response :success
    response_body = parse_response_body
    assert { response_body.length == 1 }
    assert { response_body.first['price'] == expected_price }
    assert { response_body.first['provider_name'] == @provider.name }
    assert { response_body.first['plan_name'] == @plan.name }
  end

  test '#indexは契約アンペア数と使用量を受け取り、複数のプランの料金を返す' do
    plan1 = @plan
    create(:basic_charge, plan: plan1)
    create(:usage_charge, plan: plan1)

    provider2 = create(:provider, name: 'テスト電気2')
    plan2 = create(:plan, provider: provider2, name: 'テストプラン2')
    create(:basic_charge, plan: plan2)
    create(:usage_charge, plan: plan2)

    expected_price1 = 1000
    expected_price2 = 2000
    ElectricityChargeCalculator.expects(:execute!)
      .twice
      .returns(expected_price1, expected_price2)

    get api_v1_electricity_charges_path, params: { ampere: 10, usage: 100 }

    assert_response :success
    response_body = parse_response_body

    assert { response_body.length == 2 }
    assert { response_body.first['price'] == expected_price1 }
    assert { response_body.second['price'] == expected_price2 }
    assert { response_body.first['provider_name'] == plan1.provider.name }
    assert { response_body.first['plan_name'] == plan1.name }
    assert { response_body.second['provider_name'] == plan2.provider.name }
    assert { response_body.second['plan_name'] == plan2.name }
  end

  test '#indexは契約アンペア数が空の場合に400を返す' do
    get api_v1_electricity_charges_path, params: { ampere: nil, usage: 100 }

    assert_response :bad_request
    assert { parse_response_body['error'] == '契約アンペア数(A)と使用量(kWh)は必須です。' }
  end

  test '#indexは使用量が空の場合に400を返す' do
    get api_v1_electricity_charges_path, params: { ampere: 10, usage: nil }

    assert_response :bad_request
    assert { parse_response_body['error'] == '契約アンペア数(A)と使用量(kWh)は必須です。' }
  end

  test '#indexは契約アンペア数と使用量が空の場合に400を返す' do
    get api_v1_electricity_charges_path, params: { ampere: nil, usage: nil }

    assert_response :bad_request
    assert { parse_response_body['error'] == '契約アンペア数(A)と使用量(kWh)は必須です。' }
  end

  test '#indexは契約アンペア数が無効な場合に400を返す' do
    create(:basic_charge, plan: @plan)
    create(:usage_charge, plan: @plan)

    get api_v1_electricity_charges_path, params: { ampere: 'invalid', usage: 100 }

    assert_response :bad_request
    assert { parse_response_body['error'] == '契約アンペア数(A)と使用量(kWh)は数値で指定してください。' }
  end

  test '#indexは使用量が無効な場合に400を返す' do
    create(:basic_charge, plan: @plan)
    create(:usage_charge, plan: @plan)

    get api_v1_electricity_charges_path, params: { ampere: 10, usage: 'invalid' }

    assert_response :bad_request
    assert { parse_response_body['error'] == '契約アンペア数(A)と使用量(kWh)は数値で指定してください。' }
  end

  test '#indexは従量料金区分が登録されていない場合に空配列を返す' do
    create(:basic_charge, plan: @plan)

    get api_v1_electricity_charges_path, params: { ampere: 10, usage: 100 }

    assert_response :success
    assert { parse_response_body == [] }
  end

  test '#indexは指定されたアンペア数の基本料金が存在しない場合に空配列を返す' do
    create(:usage_charge, plan: @plan)
    ampere = 10

    get api_v1_electricity_charges_path, params: { ampere: ampere, usage: 100 }

    assert_response :success
    assert { parse_response_body == [] }
  end

  test '#indexは想定外のエラーが発生した場合に500を返す' do
    ElectricityChargeCalculator.expects(:execute!).raises(StandardError)

    get api_v1_electricity_charges_path, params: { ampere: 10, usage: 100 }

    assert_response :internal_server_error
    assert { parse_response_body['error'] == 'エラーが発生しました。' }
  end
end
