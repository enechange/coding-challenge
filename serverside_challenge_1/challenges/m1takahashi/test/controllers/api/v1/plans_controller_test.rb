require "test_helper"

class Api::V1::PlansControllerTest < ActionDispatch::IntegrationTest

  test "APIのレスポンスがかえってくること" do
    get api_v1_plans_index_url
    assert_response :success
  end

  #
  # 指定アンペアで返される電力会社
  #
  
  test "10Aの場合,東京電力とLooopでんきの2件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 2
  end
  test "10Aの場合,東京電力とLooopでんきの電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") && provider_names.include?("Looopでんき")
  end

  test "15Aの場合,東京電力とLooopでんきの2件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 2
  end
  test "15Aの場合,東京電力とLooopでんきの電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") && provider_names.include?("Looopでんき")
  end

  test "20Aの場合,東京電力とLooopでんきの2件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 2
  end
  test "20Aの場合,東京電力とLooopでんきの電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") && provider_names.include?("Looopでんき")
  end

  test "30Aの場合,全ての電力会社4件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 4
  end
  test "30Aの場合,全ての電力会社を返し,電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") &&
           provider_names.include?("Looopでんき") &&
           provider_names.include?("東京ガス") &&
           provider_names.include?("JXTGでんき")
  end

  test "40Aの場合,全ての電力会社4件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 4
  end
  test "40Aの場合,全ての電力会社を返し,電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") &&
           provider_names.include?("Looopでんき") &&
           provider_names.include?("東京ガス") &&
           provider_names.include?("JXTGでんき")
  end

  test "50Aの場合,全ての電力会社4件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 4
  end
  test "50Aの場合,全ての電力会社を返し,電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") &&
           provider_names.include?("Looopでんき") &&
           provider_names.include?("東京ガス") &&
           provider_names.include?("JXTGでんき")
  end

  test "60Aの場合,全ての電力会社4件が返ること" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert_equal provider_names.count, 4
  end
  test "60Aの場合,全ての電力会社を返し,電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 123 }
    provider_names = provider_names_from_response_body(response.body)
    assert provider_names.include?("東京電力エナジーパートナー") &&
           provider_names.include?("Looopでんき") &&
           provider_names.include?("東京ガス") &&
           provider_names.include?("JXTGでんき")
  end
end
