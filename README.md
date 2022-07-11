## 対応したこと
- 電気料金の計算は、`app/services/electricity_rate_calculation.rb`にて実装しました。
  - servicesクラスを使用した理由:複数モデルの操作があるため。
- リクエストパラメータ（契約アンペア数,電気使用量）が不正な値でないか確認する処理は、`app/models/user_electron_info.rb`にて実装しました。
  - modelを使用した理由:バリデーションを使用して、簡易的に実装したいと考えたため。
- APIのテストをrequest specにて行いました。
- バリデーションのテストをmodel specにて行いました。

## 仕様に記載がなかった点の実装
- 電気使用量の最大値は99,999kWhとしました。
<br>理由:
  - プラン内容から、本APIの利用者は法人ではなく、個人と想定。
  - 以下環境省のサイトにて、「1世帯が1年間に消費したエネルギーは、全国平均で電気が4,047kWh」と発表されている。
    https://www.env.go.jp/earth/ondanka/kateico2tokei/2019/result3/detail1/index.html
  - 上記をふまえ、「99,999kWh/月」を超える電気使用量は無いと想定し、最大値を「99,999kWh」に設定しました。
    
- リクエストパラメータにて受け取った契約アンペア数を提供していないプランは、レスポンスに含めない実装としております。
<br>理由:御社サービスを参照し、本実装としました。

- 電気使用量は、必ず整数となる（少数にはならない）という実装としております。
<br>理由:以下東京電力_総則「4.単位および端数処理(3)」を参照しました。
<br>https://www4.tepco.co.jp/e-rates/custom/shiryou/yakkan/pdf/260301hosy001-j.pdf
 
## 動作確認
Heroku等へデプロイしておりません。
動作確認をして頂く場合は、お手数ですが、本リポジトリをcloneの上、curlコマンド,postman等で動作確認をお願いします。
<br>※リクエストパス等は、以下「APIの説明」に記載しております。

## APIの説明
### 概要
ユーザーから契約アンペア数(A)と1ヶ月の使用量(kWh)を受け取って、プランごとの電気料金を返すAPI

### リクエスト

#### メソッド
GET

#### パス
```
http://localhost:3000/api/electricity_rate_plans
```

#### パラメータ
| パラメータ | 型     | 内容      |
|-----|-------|---------|
| contract_amperage | integer | 契約アンペア数 |
| electricity_usage    | integer | 電気使用量 |

#### リクエストサンプル
```
http://localhost:3000/api/electricity_rate_plans?contract_amperage=30&electricity_usage=400
```

### レスポンス
#### 成功時
- ステータスコード:200

##### レスポンスオブジェクト
| パラメータ         | 型       | 内容    |
|---------------|---------|-------|
| provider_name | string  | 電力会社名 |
| plan_name     | string  | プラン名  |
| price         | integer | 電気料金  |

##### レスポンスサンプル
```
[
    {
        "provider_name": "東京電力エナジーパートナー",
        "plan_name": "従量電灯B",
        "price": 11067
    },
    {
        "provider_name": "Loopでんき",
        "plan_name": "おうちプラン",
        "price": 10560
    },
    {
        "provider_name": "東京ガス",
        "plan_name": "ずっとも電気1",
        "price": 10507
    },
    {
        "provider_name": "JXTGでんき",
        "plan_name": "従量電灯Bたっぷりプラン",
        "price": 10518
    }
]

```

#### 失敗時（リクエストパラメータが不正な値の場合）
- ステータスコード:400

##### レスポンスオブジェクト
| パラメータ     | 型       | 内容    |
|-----------|---------|-------|
| errors    | array   | エラー内容 |

##### レスポンスサンプル
```
{
    "errors": {
        "contract_amperage": [
            "未入力です。",
            "[10, 15, 20, 30, 40, 50, 60]内、いずれかの数値を入力してください。"
        ],
        "electricity_usage": [
            "未入力です。",
            "0以上、99999以下の整数を入力してください。"
        ]
    }
}
```
