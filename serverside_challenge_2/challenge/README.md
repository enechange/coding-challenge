# 電気料金出力API
## 概要
与えられたリクエスト値を元に、一致する電力会社/プランの料金を返却するAPIです。

## API仕様
### エンドポイント
```
GET electricity_charges/calculate
```

### リクエスト値

| パラメータ名 | 説明      | データ型 | パラメータ制限                    | 備考      |
|--------|---------|------|----------------------------|---------|
| ampere | 契約アンペア数 | int  | 10/15/20/30/40/50/60 のいずれか | 単位: A   |
| usage  | 電力使用量   | int  | 0以上の整数                     | 単位: kWh |

### レスポンス
| パラメータ名        | 説明    | データ型   | 備考 |
|---------------|-------|--------|----|
| provider_name | 電力会社名 | string |    |
| plan_name     | プラン名  | string |    |
| price         | 値段    | float  |    |

### レスポンスのサンプル
#### 一致するプランがある場合

```json lines
// GET http://localhost:3000/electricity_charges/calculate?ampere=30&usage=10

[
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "従量電灯B",
    "price": 1056.8
  },
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "スタンダードS",
    "price": 1233.25
  },
  {
    "provider_name": "東京ガス",
    "plan_name": "ずっとも電気1",
    "price": 1094.7
  },
  {
    "provider_name": "Looopでんき",
    "plan_name": "おうちプラン",
    "price": 288.0
  }
]
```

#### 一致するプランがない場合

```json
[
  {
    "message": "ampereに一致するプランが登録されていません"
  }
]
```


#### パラメータが不正な場合

```json

{
  "error": "ampereの値が正しくありません"
}
```