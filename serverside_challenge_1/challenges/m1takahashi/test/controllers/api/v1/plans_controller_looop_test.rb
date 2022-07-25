require "test_helper"

# Looopでんき
class Api::V1::PlansControllerLooopTest < ActionDispatch::IntegrationTest

  setup do
    # 結果が配列で返ってくるので,電力会社名で特定する
    @provider_name = "Looopでんき"
  end

  #
  # 電力会社名・プラン名
  #
  test "電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["provider_name"], "Looopでんき"
  end

  test "プラン名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["plan_name"], "おうちプラン"
  end

  #
  # 基本料金のみ（全て0円）
  #
  test "10Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "15Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "20Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "30Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "40Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "50Aの基本料金のみの場合には,0円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  test "60Aの基本料金のみの場合には,1716円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 0
  end

  #
  # 基本料金（0円）+ 従量料金
  # テストケースは,東京電力を流用
  #
  
  # 0 + 26.40 * 120 = 3168 
  test "基本料金と従量料金（120kWh）の場合,3168円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 120 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 3168
  end
  
  # 0 + 26.40 * 121 = 3194.4（切り上げ:3195） 
  test "基本料金と従量料金（121kWh）の場合,3195円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 121 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 3195
  end
  
  # 0 + 26.40 * 300 = 7920
  test "基本料金と従量料金（300kWh）の場合,7920円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 300 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 7920
  end
  
  # 0 + 26.40 * 301 = 7946.4（切り上げ:7947） 
  test "基本料金と従量料金（301kWh）の場合,7947円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 301 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 7947
  end
end
