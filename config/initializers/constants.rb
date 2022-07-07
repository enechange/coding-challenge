module Constants
  # 契約アンペア数 : 10 / 15 / 20 / 30 / 40 / 50 / 60 のいずれかとなる。
  CONTRACT_AMPERAGE_TYPE = [10, 15, 20, 30, 40, 50, 60]

  # 電気使用量の最大値
  # 「法人のひと月の電気使用量30,000kWh」と例示されており、「99999/月」を超える
  # 電気使用量は無いと想定し、最大値を「99999」に設定
  # 参照先：https://miraiz.chuden.co.jp/business/electric/contract/factory/hi_price/calcexample/index.html
  MAXIMUM_ELECTRICITY_USAGE = 99999
end
