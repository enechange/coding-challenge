## API エンドポイント仕様

### **API エンドポイント**
| メソッド | エンドポイント | 説明 |
|----------|--------------|------|
| `GET`    | `/simulate?ampere={契約アンペア数}&usage={使用電力量}` | 指定したアンペア数・使用量に基づく電気料金シミュレーションを実行 |

---

### **リクエスト仕様**
#### **クエリパラメータ**
| パラメータ | 型 | 必須 | 説明 |
|------------|----|------|------|
| `ampere`   | `Integer` | ✅ | 契約アンペア数（`10, 15, 20, 30, 40, 50, 60` のいずれか） |
| `usage`    | `Integer` | ✅ | 使用電力量（`0` 以上の整数） |

#### **リクエスト例**
```bash
curl -X GET "http://localhost:3000/simulate?ampere=30&usage=20" -H "Content-Type: application/json"
```

##API レスポンス仕様

### **レスポンスフォーマット**
API は JSON 形式でレスポンスを返します。

```json
[
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "従量電灯B",
    "price": 1255
  },
  {
    "provider_name": "東京電力エナジーパートナー",
    "plan_name": "スタンダードS",
    "price": 1531
  },
  {
    "provider_name": "東京ガス",
    "plan_name": "ずっとも電気1",
    "price": 1331
  },
  {
    "provider_name": "Looopでんき",
    "plan_name": "おうちプラン",
    "price": 576
  }
]
```

## エラーハンドリング (`400 Bad Request`)

API で **無効なパラメータ** が送信された場合、`400 Bad Request` を返します。

---

### **エラー時のレスポンスフォーマット**
```json
{
 "error":"アンペアと使用量の値が不正です"
}

```