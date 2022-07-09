## 電気料金プランAPI
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
