require "test_helper"

# バリデーションのテスト
class Api::V1::PlansControllerValidationTest < ActionDispatch::IntegrationTest

  #
  # 契約アンペア数
  #
  test "契約アンペア数パラメータがない場合にはエラーになること" do
    get api_v1_plans_index_url, params: { amount: 121 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "契約アンペア数が正しくありません。"
  end

  #
  # 契約アンペア数（許可アンペア数以外）
  #
  test "契約アンペア数パラメータに,5(A)が指定された場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 5, amount: 121 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "契約アンペア数が正しくありません。"
  end
  test "契約アンペア数パラメータに,25(A)が指定された場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 25, amount: 121 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "契約アンペア数が正しくありません。"
  end
  test "契約アンペア数パラメータに,65(A)が指定された場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 65, amount: 121 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "契約アンペア数が正しくありません。"
  end

  #
  # 使用量
  #
  test "使用量パラメータがない場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 30 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "使用量を入力して下さい。"
  end

  test "使用量がマイナスの場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: -1 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "使用量の入力は、0から999,999の数値で入力して下さい。"
  end

  test "使用量が999,999を超える場合にはエラーになること" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 1000000 }
    res = JSON.parse(response.body)
    assert res["code"] == 1 && res["message"] == "使用量の入力は、0から999,999の数値で入力して下さい。"
  end
end
