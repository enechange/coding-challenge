require "test_helper"

# JXTGでんき
class Api::V1::PlansControllerJxtgTest < ActionDispatch::IntegrationTest

  setup do
    # 結果が配列で返ってくるので,電力会社名で特定する
    @provider_name = "JXTGでんき"
  end

  #
  # 電力会社名・プラン名
  #
  test "電力会社名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["provider_name"], "JXTGでんき"
  end

  test "プラン名が正しいこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["plan_name"], "従量電灯Bたっぷりプラン"
  end

  #
  # 基本料金のみ
  #
  test "10Aの基本料金のみの場合には,nilを返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_nil plan
  end

  test "15Aの基本料金のみの場合には,nilを返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_nil plan
  end

  test "20Aの基本料金のみの場合には,nilを返すこと" do
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

  # 1716.8 => 1717に切り上がる
  test "60Aの基本料金のみの場合には,1717円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 0 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 1717
  end

  #
  # 基本料金（30A） + 従量料金
  #
  
  # 858 + 19.88 * 120 = 3243.6（切り上げ:3244）
  test "30Aの基本料金と『最初の120kWhまで』の場合,3244円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 120 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 3244
  end
  
  # 858 + 26.48 * 121 = 4062.08（切り上げ:4063） 
  test "30Aの基本料金と『120kWhをこえ300kWhまで（121kWh）』の場合,4063円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 121 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4063
  end
  
  # 858 + 26.48 * 300 = 8802
  test "30Aの基本料金と『120kWhをこえ300kWhまで（300kWh）』の場合,8802円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 300 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 8802
  end
  
  # 858 + 25.08 * 301 = 8407.08（切り上げ:8408）
  test "30Aの基本料金と『300kWhをこえ600kWhまで（301kWh）』の場合,8408円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 301 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 8408
  end

  # 858 + 25.08 * 600 = 15906
  test "30Aの基本料金と『300kWhをこえ600kWhまで（600kWh）』の場合,15906円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 600 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 15906
  end

  # 858 + 26.15 * 601 = 16574.15（切り上げ:16575）
  test "30Aの基本料金と『600kWhをこえる分』の場合,16575円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 601 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 16575
  end

  #
  # 基本料金（40A） + 従量料金
  #
  
  # 1144 + 19.88 * 120 = 3529.6（切り上げ:3530）
  test "40Aの基本料金と『最初の120kWhまで』の場合,3530円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 120 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 3530
  end
  
  # 1144 + 26.48 * 121 = 4348.08（切り上げ:4349） 
  test "40Aの基本料金と『120kWhをこえ300kWhまで（121kWh）』の場合,4349円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 121 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4349
  end
  
  # 1144 + 26.48 * 300 = 9088
  test "40Aの基本料金と『120kWhをこえ300kWhまで（300kWh）』の場合,9088円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 300 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9088
  end
  
  # 1144 + 25.08 * 301 = 8693.08（切り上げ:8694）
  test "40Aの基本料金と『300kWhをこえ600kWhまで（301kWh）』の場合,8694円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 301 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 8694
  end

  # 1144 + 25.08 * 600 = 16192
  test "40Aの基本料金と『300kWhをこえ600kWhまで（600kWh）』の場合,16192円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 600 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 16192
  end

  # 1144 + 26.15 * 601 = 16861
  test "40Aの基本料金と『600kWhをこえる分（601kWh）』の場合,16861円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 601 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 16861
  end

  #
  # 基本料金（50A） + 従量料金
  #
  
  # 1430 + 19.88 * 120 = 3815.6（切り上げ:3816）
  test "50Aの基本料金と『最初の120kWhまで』の場合,3816円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 120 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 3816
  end
  
  # 1430 + 26.48 * 121 = 4634.08（切り上げ:4635）
  test "50Aの基本料金と『120kWhをこえ300kWhまで（121kWh）』の場合,4635円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 121 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4635
  end
  
  # 1430 + 26.48 * 300 = 9374
  test "50Aの基本料金と『120kWhをこえ300kWhまで（300kWh）』の場合,9374円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 300 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9374
  end
  
  # 1430 + 25.08 * 301 = 8979.08（切り上げ:8980）
  test "50Aの基本料金と『300kWhをこえ600kWhまで（301kWh）』の場合,8980円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 301 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 8980
  end

  # 1430 + 25.08 * 600 = 16478
  test "50Aの基本料金と『300kWhをこえ600kWhまで（600kWh）』の場合,16478円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 600 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 16478
  end

  # 1430 + 26.15 * 601 = 17146.15
  test "50Aの基本料金と『600kWhをこえる分（601kWh）』の場合,17147円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 601 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 17147
  end

  #
  # 基本料金（60A） + 従量料金
  #
  
  # 1716.8 + 19.88 * 120 = 4102.4（切り上げ:4103）
  test "60Aの基本料金と『最初の120kWhまで』の場合,4103円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 120 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4103
  end
  
  # 1716.8 + 26.48 * 121 = 4920.88（切り上げ:4921）
  test "60Aの基本料金と『120kWhをこえ300kWhまで（121kWh）』の場合,4921円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 121 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 4921
  end
  
  # 1716.8 + 26.48 * 300 = 9660.8
  test "60Aの基本料金と『120kWhをこえ300kWhまで（300kWh）』の場合,9661円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 300 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9661
  end
  
  # 1716.8 + 25.08 * 301 = 9265.88（切り上げ:9266）
  test "60Aの基本料金と『300kWhをこえ600kWhまで（301kWh）』の場合,9266円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 301 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 9266
  end

  # 1716.8 + 25.08 * 600 = 16764.8（切り上げ:16765）
  test "60Aの基本料金と『300kWhをこえ600kWhまで（600kWh）』の場合,16765円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 600 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 16765
  end

  # 1716.8 + 26.15 * 601 = 17432.95（切り上げ:17433）
  test "60Aの基本料金と『600kWhをこえる分（601kWh）』の場合,17433円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 601 }
    plan = plan_from_response_body(@provider_name , response.body)
    assert_equal plan["price"], 17433
  end
end
