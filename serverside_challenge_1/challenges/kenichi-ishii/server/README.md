# README

### 使用方法

#### docker起動
```
docker-compose up -d
```

#### アクセス
http://localhost:3000


#### APIについて
- URL: /electricity_rates/calculation

- method: post

- parameter:
    - ampere (number, required) - 契約アンペア数
    - usage (number, required) - 電気使用量

- response (application/json) 

```
[
    {
        "provider_name": "provider_name",
        "plan_name": "plan_name",
        "price": 1000
    }
    ...
]
```
