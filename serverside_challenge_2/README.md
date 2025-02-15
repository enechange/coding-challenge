## 課題

ENECHANGEでは各電力会社向けに、電気料金のシミュレーション機能を提供しています。

ユーザーから契約アンペア数(A)と1ヶ月の使用量(kWh)を受け取って、プランごとの電気料金を返すAPIを実装してください。

### 電気料金の計算方法
電気料金は一般的に以下の計算で算出します。

```
電気料金 = ①基本料金 + ②従量料金 + ③そのほか
```

本課題においては簡略化のため `③そのほか`は無視して良いものとします。</br>
詳細は[主な契約種別の料金計算式](https://www.tepco.co.jp/ep/private/plan2/chargelist04.html#sec03)を参照してください。

#### ①基本料金
`契約アンペア数(A)`に対応する`基本料金(円)`によって定まります。</br>
例えば、東京電力エナジーパートナーの従量電灯Bの場合、40Aで1,144円、60Aで1,716円となっています。

#### ②従量料金
`電気使用量(kWh) * 従量料金単価(円/kWh)`によって定まり、たくさん使えば使うほど料金は高くなります。</br>

#### ③そのほか
燃料費調整額や再生可能エネルギー賦課金など。今回は考慮する必要はありません。

### 対象プランと料金表
対象とする 電力会社 / プランは、以下の４つとします
※ 参考URLは料金体系やプラン特性の参考情報です。単価はREADMEの表を正としてください。

#### 東京電力エナジーパートナー / 従量電灯B([参考](http://www.tepco.co.jp/ep/private/plan/old01.html))

| 契約アンペア数(A) | 基本料金(円) |
|---|---|
| 10 | 286.00 |
| 15 | 429.00 |
| 20 | 572.00 |
| 30 | 858.00 |
| 40 | 1144.00 |
| 50 | 1430.00 |
| 60 | 1716.00 |

| 電気使用量(kWh) | 従量料金単価(円/kWh) |
| ---|---|
| 0-120 | 19.88 |
| 121-300 | 26.48 |
| 301 | 30.57 |


#### 東京電力エナジーパートナー / スタンダードS([参考](https://www.tepco.co.jp/ep/private/plan/standard/kanto/index-j.html))

| 契約アンペア数(A) | 基本料金(円) |
|---|---|
| 10 | 311.75 |
| 15 | 467.63 |
| 20 | 623.50 |
| 30 | 935.25 |
| 40 | 1247.00 |
| 50 | 1558.75 |
| 60 | 1870.50 |

| 電気使用量(kWh) | 従量料金単価(円/kWh) |
| ---|---|
| 0-120 | 29.80 |
| 121-300 | 36.40 |
| 301 | 40.49 |


#### 東京ガス / ずっとも電気1([参考](https://home.tokyo-gas.co.jp/power/ryokin/menu_waribiki/menu1.html))

| 契約アンペア数(A) | 基本料金(円) |
|---|---|
| 30 | 858.00 |
| 40 | 1144.00 |
| 50 | 1430.00 |
| 60 | 1716.00 |

| 電気使用量(kWh) | 従量料金単価(円/kWh) |
| ---|---|
| 0-140 | 23.67 |
| 141-350 | 23.88 |
| 351 | 26.41 |


#### Looopでんき / おうちプラン([参考](https://looop-denki.com/home/menu/plan/ouchi/))

| 契約アンペア数(A) | 基本料金(円) |
|---|---|
| 10 | 0.00 |
| 15 | 0.00 |
| 20 | 0.00 |
| 30 | 0.00 |
| 40 | 0.00 |
| 50 | 0.00 |
| 60 | 0.00 |

| 電気使用量(kWh) | 従量料金単価(円/kWh) |
| ---|---|
| 0 | 28.8 |


## 要件

### 基本項目

- リクエスト
  - 契約アンペア数 : `10 / 15 / 20 / 30 / 40 / 50 / 60` のいずれかとする(単位`A`)
  - 使用量 : 0以上の整数(単位`kWh`)
- レスポンス
  - 電力会社名(`provider_name`) / プラン名(`plan_name`) / 電気料金(`price`)
    - ex.)  `[{ provider_name: ‘Looopでんき’, plan_name: ‘おうちプラン’, price: ‘1234’ }, …]`
  - エラーの場合は適切にエラーメッセージを返却する

- データは、CSVやYAMLなどのファイルで管理して読み込んでください
- リクエスト形式
  - ご自由に考えてくださって構いません
- レスポンス形式
  - ご自由に考えてくださって構いません

### 追加項目
以下の追加要件を実装することで、評価に加点いたします。
(上から順に実装する必要はございません。得意なものでアピールしてください。)

- フロントエンドを実装し、実装したAPIを利用して料金を表示する
- 料金データをDBで管理できるようにする
- 本番環境へのデプロイ
  - インフラサービスは問いません
- レビュー後の対応

## 確認ポイント
以下の内容を特に確認させていただきます。

- 要求仕様を正しく理解し、実装に反映できること
- オブジェクト指向に基づいた設計がなされていること
  - 同様の料金体系のプランが対象プランに追加された場合も、ロジックを追加せずに済むようにしてください
- レビューに対する対応力

## 提出形式
1. このRepositoryをForkしてください。
1. `## 環境構築`に従って環境構築をおこなってください
1. このRepositoryへのPull Requestを作成してください

## 環境構築

```
$ docker compose up
$ docker compose exec web bash
root@0fcf1ebe5546:/app# rails db:create
```
