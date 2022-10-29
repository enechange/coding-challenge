
## バージョン情報
- Ruby on Rails 6.1.7
- Ruby 3.1.2
- Mysql 8.0.31

## APIの説明
### 概要
ユーザーから契約アンペア数(A)と1ヶ月の使用量(kWh)を受け取って、プランごとの電気料金を返すAPI

#### パラメータ
| パラメータ | 型     | 内容      |
|-----|-------|---------|
| contract_amperage | integer | 契約アンペア数 |
| electricity_usage    | integer | 電気使用量 |

#### リクエストサンプル
```
http://localhost:3000/api/electricity_rate_plans?contract_amperage=30&electricity_usage=100
```

### レスポンス
#### 仕様
- パラメータにて受け取った契約アンペア数を提供していないプランは、レスポンスに含まれない。
- 合計金額は整数表示

#### 成功時
- ステータスコード:200

##### レスポンスオブジェクト
| パラメータ         | 型       | 内容    |
|---------------|---------|-------|
| provider_name | string  | 電力会社名 |
| plan_name     | string  | プラン名  |
| price         | integer | 電気料金  |

##### レスポンスサンプル

- 契約アンペア数30A、電気使用量100kWhの場合
```
[
    {
        "provider_name": "東京電力エナジーパートナー",
        "plan_name": "従量電灯B",
        "price": 2846
    },
    {
        "provider_name": "Loopでんき",
        "plan_name": "おうちプラン",
        "price": 2640
    },
    {
        "provider_name": "東京ガス",
        "plan_name": "ずっとも電気1",
        "price": 3225
    },
    {
        "provider_name": "JXTGでんき",
        "plan_name": "従量電灯Bたっぷりプラン",
        "price": 2846
    }
]

```

#### 失敗時（リクエストパラメータが不正な値の場合）
- ステータスコード:400

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
            "正の整数を入力してください。"
        ]
    }
}
```
