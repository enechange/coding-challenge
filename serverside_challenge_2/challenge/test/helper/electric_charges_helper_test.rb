require "test_helper"

class ElectricityChargesHelperTest < ActionDispatch::IntegrationTest
  include ElectricChargesHelper
  test '[validate_params]正常系: 契約アンペア数 30A, 使用量 100kWh' do
    params = { ampere: "30", usage: "100" }
    assert_nil validate_params(params)
  end

  test '[validate_params]異常系: 契約アンペア数 0A' do
    params = { ampere: "0", usage: "100" }
    error, status = validate_params(params)
    assert_equal({ error: 'ampereの値が正しくありません' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 使用量 -1kWh' do
    params = { ampere: "30", usage: "-1" }
    error, status = validate_params(params)
    assert_equal({ error: 'usageは0以上の整数を設定してください' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 契約アンペア数 "abc" (型が不正)' do
    params = { ampere: "abc", usage: "100" }
    error, status = validate_params(params)
    assert_equal({ error: 'ampereの値が正しくありません' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: 使用量 "abc" (型が不正)' do
    params = { ampere: "30", usage: "abc" }
    error, status = validate_params(params)
    assert_equal({ error: 'usageは0以上の整数を設定してください' }, error)
    assert_equal :bad_request, status
  end

  test '[validate_params]異常系: パラメータが空' do
    params = {}
    error, status = validate_params(params)
    assert_equal({ error: 'リクエストパラメータにampereとusageを設定してください' }, error)
    assert_equal :bad_request, status
  end

  test '[import_price_from_yaml] 正常系テスト1: 契約アンペア数30A, 使用量100kWh' do
    result, status = import_price_from_yaml(30, 100)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 2846.0  },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 3915.25 },
      { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 3225.0 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 2880.0 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end

  test '[import_price_from_yaml] 正常系テスト2: 契約アンペア数10A, 使用量0kWh' do
    result, status = import_price_from_yaml(10, 0)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 286.0  },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 311.75 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 0.0 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end

  test '[import_price_from_yaml] 正常系テスト3: 契約アンペア数60A, 使用量1000kWh' do
    result, status = import_price_from_yaml(60, 1000)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 32286.0  },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 42360.5 },
      { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 28126.0 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 28800.0 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end

  test '[import_price_from_yaml] 正常系テスト4: 契約アンペア数40A, 使用量200kWh' do
    result, status = import_price_from_yaml(40, 200)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 6440.0  },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 8527.0 },
      { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 5920.0 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 5760.0 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end

  test '[import_price_from_yaml] 異常系テスト: アンペア数に一致するプランがない場合' do
    result, status = import_price_from_yaml(5, 10)
    expected = [
      { message: "ampereに一致するプランが登録されていません"},
    ]
    assert_equal expected, result
    assert_equal 404, status
  end

  test '[import_price_from_yaml] 境界値テスト1: 契約アンペア数10A, 使用量120kWh' do
    result, status = import_price_from_yaml(10, 120)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 2671.6  },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 3887.75 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 3456.0 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end

  test '[import_price_from_yaml] 境界値テスト2: 契約アンペア数60A, 使用量351kWh' do
    result, status = import_price_from_yaml(60, 351)
    expected = [
      { provider_name: '東京電力エナジーパートナー', plan_name: '従量電灯B', price: 12446.07 },
      { provider_name: '東京電力エナジーパートナー', plan_name: 'スタンダードS', price: 16082.49 },
      { provider_name: '東京ガス', plan_name: 'ずっとも電気1', price: 10985.91 },
      { provider_name: 'Looopでんき', plan_name: 'おうちプラン', price: 10108.8 },
    ]
    assert_equal expected, result
    assert_equal 200, status
  end
end