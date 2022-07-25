require "test_helper"

# 東京ガス
class Api::V1::PlansControllerTokyogasTest < ActionDispatch::IntegrationTest

  setup do
    # 結果が配列で返ってくるので,電力会社名で特定する
    @provider_name = "東京ガス"
  end

  #
  # 電力会社名・プラン名
  #
  test "電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["provider_name"], "東京ガス"
  end

  test "プラン名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["plan_name"], "ずっとも電気1"
  end

  #
  # 基本料金のみ
  #
  test "10Aの基本料金のみの場合には,nilが返ること" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_nil plan
  end

  test "15Aの基本料金のみの場合には,nilが返ること" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_nil plan
  end

  test "20Aの基本料金のみの場合には,nilが返ること" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_nil plan
  end

  test "30Aの基本料金のみの場合には,858円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 858
  end

  test "40Aの基本料金のみの場合には,858円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 1144
  end

  test "50Aの基本料金のみの場合には,1430円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 1430
  end

  test "60Aの基本料金のみの場合には,1716円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 1716
  end

  #
  # 基本料金（30A） + 従量料金
  #
  
  # 858 + 23.67 * 140 = 4171.8（切り上げ:4172）
  test "30Aの基本料金と『最初の140kWhまで』の場合,4172円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 140 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4172
  end
  
  # 858 + 23.88 * 141 = 4225.08（切り上げ:4226） 
  test "30Aの基本料金と『140kWhをこえ350kWhまで（141kWh）』の場合,4226円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 141 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4226
  end
  
  # 858 + 23.88 * 350 = 9216
  test "30Aの基本料金と『140kWhをこえ350kWhまで（350kWh）』の場合,9216円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 350 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9216
  end
  
  # 858 + 26.41 * 351 = 10127.91（切り上げ:10128）
  test "30Aの基本料金と『350kWhをこえる分（351kWh）』の場合,10128円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 351 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 10128
  end

  #
  # 基本料金（40A） + 従量料金
  #
  
  # 1144 + 23.67 * 140 = 4457.8（切り上げ:4458）
  test "40Aの基本料金と『最初の140kWhまで』の場合,3530円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 140 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4458
  end
  
  # 1144 + 23.88 * 141 = 4511.08（切り上げ:4512） 
  test "40Aの基本料金と『140kWhをこえ350kWhまで（141kWh）』の場合,4512円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 141 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4512
  end
  
  # 1144 + 23.88 * 300 = 9502
  test "40Aの基本料金と『140kWhをこえ350kWhまで（350kWh）』の場合,9502円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 350 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9502
  end
  
  # 1144 + 26.41 * 351 = 10413.91（切り上げ:10414）
  test "40Aの基本料金と『350kWhをこえる分（351kWh）』の場合,10414円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 351 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 10414
  end

  #
  # 基本料金（50A） + 従量料金
  #
  
  # 1430 + 23.67 * 140 = 4743.8（切り上げ:4744）
  test "50Aの基本料金と『最初の140kWhまで』の場合,4744円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 140 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4744
  end
  
  # 1430 + 23.88 * 141 = 4797.08（切り上げ:4798）
  test "50Aの基本料金と『140kWhをこえ350kWhまで（141kWh）』の場合,4798円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 141 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4798
  end
  
  # 1430 + 23.88 * 350 = 9788
  test "50Aの基本料金と『140kWhをこえ350kWhまで（350kWh）』の場合,9788円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 350 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9788
  end
  
  # 1430 + 26.41 * 351 = 10699.91（切り上げ:10700）
  test "50Aの基本料金と『350kWhをこえる分（351kWh）』の場合,10700円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 351 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 10700
  end

  #
  # 基本料金（60A） + 従量料金
  #
  
  # 1716 + 23.67 * 140 = 5029.8（切り上げ:5030）
  test "60Aの基本料金と『最初の140kWhまで』の場合,5030円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 140 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 5030
  end
  
  # 1716 + 23.88 * 141 = 5083.08（切り上げ:5084）
  test "60Aの基本料金と『140kWhをこえ350kWhまで（141kWh）』の場合,5084円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 141 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 5084
  end
  
  # 1716 + 23.88 * 350 = 10074
  test "60Aの基本料金と『140kWhをこえ350kWhまで（350kWh）』の場合,10074円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 350 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 10074
  end
  
  # 1716 + 26.41 * 351 = 10985.91（切り上げ:10986）
  test "60Aの基本料金と『350kWhをこえる分（351kWh）』の場合,10986円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 351 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 10986
  end
end
