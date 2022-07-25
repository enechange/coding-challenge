require "test_helper"

# 東京電力エナジーパートナー
class Api::V1::PlansControllerTepcoTest < ActionDispatch::IntegrationTest

  setup do
    # 結果が配列で返ってくるので,電力会社名で特定する
    @provider_name = "東京電力エナジーパートナー"
  end

  #
  # 基本料金のみ
  #
  test "10Aの基本料金のみの場合には,286円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 286
  end

  test "15Aの基本料金のみの場合には,429円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 429
  end

  test "20Aの基本料金のみの場合には,572円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 572
  end

  test "30Aの基本料金のみの場合には,858円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 858
  end

  test "40Aの基本料金のみの場合には,858円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 1144
  end

  test "50Aの基本料金のみの場合には,1430円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 1430
  end

  test "60Aの基本料金のみの場合には,1716円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 0 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 1716
  end

  #
  # 基本料金（10A） + 従量料金
  #
  
  # 286 + 19.88 * 120 = 2671.6（切り上げ:2672） 
  test "10Aの基本料金と『最初の120kWhまで』の場合,2672円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 2672
  end
  
  # 286 + 26.48 * 121 = 3490.08（切り上げ:3491） 
  test "10Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,3491円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3491
  end
  
  # 286 + 26.48 * 300 = 8230 
  test "10Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,8230円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 8230
  end
  
  # 286 + 30.57 * 301 = 9487.57（切り上げ:9488） 
  test "10Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,9488円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 10, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9488
  end

  #
  # 基本料金（15A） + 従量料金
  #
  
  # 429 + 19.88 * 120 = 2814.6（切り上げ:2815） 
  test "15Aの基本料金と『最初の120kWhまで』の場合,2815円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 2815
  end
  
  # 429 + 26.48 * 121 = 3633.08（切り上げ:3634） 
  test "15Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,3634円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3634
  end
  
  # 429 + 26.48 * 300 = 8373
  test "15Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,8373円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 8373
  end
  
  # 429 + 30.57 * 301 = 9630.57（切り上げ:9631） 
  test "15Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,9631円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 15, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9631
  end

  #
  # 基本料金（20A） + 従量料金
  #
  
  # 572 + 19.88 * 120 = 2957.6（切り上げ:2958） 
  test "20Aの基本料金と『最初の120kWhまで』の場合,2958円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 2958
  end
  
  # 572 + 26.48 * 121 = 3776.08（切り上げ:3777） 
  test "20Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,3777円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3777
  end
  
  # 572 + 26.48 * 300 = 8516
  test "20Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,8516円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 8516
  end
  
  # 572 + 30.57 * 301 = 9773.57（切り上げ:9774）
  test "20Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,9774円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 20, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9774
  end

  #
  # 基本料金（30A） + 従量料金
  #
  
  # 858 + 19.88 * 120 = 3243.6（切り上げ:3244）
  test "30Aの基本料金と『最初の120kWhまで』の場合,3244円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3244
  end
  
  # 858 + 26.48 * 121 = 4062.08（切り上げ:4063） 
  test "30Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,4063円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 4063
  end
  
  # 858 + 26.48 * 300 = 8802
  test "30Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,8802円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 8802
  end
  
  # 858 + 30.57 * 301 = 10059.57（切り上げ:10060）
  test "30Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,10060円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 30, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 10060
  end

  #
  # 基本料金（40A） + 従量料金
  #
  
  # 1144 + 19.88 * 120 = 3529.6（切り上げ:3530）
  test "40Aの基本料金と『最初の120kWhまで』の場合,3530円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3530
  end
  
  # 1144 + 26.48 * 121 = 4348.08（切り上げ:4349） 
  test "40Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,4349円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 4349
  end
  
  # 1144 + 26.48 * 300 = 9088
  test "40Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,9088円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9088
  end
  
  # 1144 + 30.57 * 301 = 10345.57（切り上げ:10346）
  test "40Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,10346円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 40, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 10346
  end

  #
  # 基本料金（50A） + 従量料金
  #
  
  # 1430 + 19.88 * 120 = 3815.6（切り上げ:3816）
  test "50Aの基本料金と『最初の120kWhまで』の場合,3816円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 3816
  end
  
  # 1430 + 26.48 * 121 = 4634.08（切り上げ:4635）
  test "50Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,4635円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 4635
  end
  
  # 1430 + 26.48 * 300 = 9374
  test "50Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,9374円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9374
  end
  
  # 1430 + 30.57 * 301 = 10631.57（切り上げ:10632）
  test "50Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,10632円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 50, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 10632
  end

  #
  # 基本料金（60A） + 従量料金
  #
  
  # 1716 + 19.88 * 120 = 4101.6（切り上げ:4102）
  test "60Aの基本料金と『最初の120kWhまで』の場合,4102円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 120 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 4102
  end
  
  # 1716 + 26.48 * 121 = 4920.08（切り上げ:4921）
  test "60Aの基本料金と『最初の120kWhをこえ300kWhまで（121kWh）』の場合,4921円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 121 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 4921
  end
  
  # 1716 + 26.48 * 300 = 9660
  test "60Aの基本料金と『最初の120kWhをこえ300kWhまで（300kWh）』の場合,9660円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 300 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 9660
  end
  
  # 1716 + 30.57 * 301 = 10917.57（切り上げ:10918）
  test "60Aの基本料金と『最初の300kWhをこえる分（301kWh）』の場合,10918円を返すこと" do
    get api_v1_plans_index_url, params: { ampere: 60, amount: 301 }
    res = JSON.parse(response.body)
    plans = res["data"].select{|item| item["provider_name"] == @provider_name }
    plan = plans.shift
    assert_equal plan["price"], 10918
  end
end
