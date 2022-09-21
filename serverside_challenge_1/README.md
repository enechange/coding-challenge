## 課題
ENECHANGEでは各電力会社向けに、電気料金のシミュレーション機能を提供しています。

ユーザーから契約アンペア数(A)と1ヶ月の使用量(kWh)を受け取って、プランごとの電気料金を返すAPIを実装してください。

## 要件
### 基本項目
- リクエスト
  - 契約アンペア数 : `10 / 15 / 20 / 30 / 40 / 50 / 60` のいずれかとする。（単位`A`）
  - 使用量 : 0以上の整数（単位`kWh`）
- レスポンス
  - 電力会社名(`provider_name`) / プラン名(`plan_name`) / 電気料金(`price`)	
    - ex.)  `[{ provider_name: ‘Looopでんき’, plan_name: ‘おうちプラン’, price: ‘1234’ }, …]`  
  - エラーの場合は適切にエラーメッセージを返却する。
- 対象とする 電力会社 / プランは、以下の４つとする。（各料金表は後述）
  - 東京電力エナジーパートナー / 従量電灯B （[参考](http://www.tepco.co.jp/ep/private/plan/old01.html)）
  - Loopでんき / おうちプラン （[参考](https://looop-denki.com/low-v/plan/)）
  - 東京ガス / ずっとも電気1 （[参考](https://home.tokyo-gas.co.jp/power/ryokin/menu_waribiki/menu1.html)）
  - JXTGでんき / 従量電灯Bたっぷりプラン （[参考](https://mydenki.jp/files/plan_tappuri.pdf)）

### 料金
<img src="https://user-images.githubusercontent.com/1951287/150285118-01b72e4b-93a2-4d57-9e0c-861d60827f60.png" width="400px"> <img src="https://user-images.githubusercontent.com/1951287/150285466-2ef6c23a-f3a9-4123-9c1f-a1b3aed610c2.png" width="400px">
<img src="https://user-images.githubusercontent.com/1951287/150285521-338b0083-b297-4b26-af45-64d8546f0d12.png" width="400px"> <img src="https://user-images.githubusercontent.com/1951287/150285556-c69c2b6e-955a-4769-b64e-1785e4e27d81.png" width="400px">


### 電気料金の計算方法
電気料金は一般的に以下の計算で算出するが、本課題においては簡略化のため `③そのほか`は無視して良いものとする。
```
電気料金 = ①基本料金 + ②従量料金 + ③そのほか
```

#### ① 基本料金
契約アンペア数によって定まる。
例えば、東京電力エナジーパートナーの従量電灯Bの場合、40Aで1,144円、60Aで1,716円となっている。

#### ② 従量料金
電気使用量（kWh）によって定まり、たくさん使えば使うほど料金は高くなる。

#### ③ そのほか
燃料費調整額や再生可能エネルギー賦課金など。今回は考慮しなくて良い。

####　詳細
[料金計算方法の詳細](https://www.tepco.co.jp/ep/private/plan2/chargelist04.html#sec03)を参照してください。

### そのほか
- サーバーサイドは、Ruby on Railsを用いて実装してください。
- データは、CSVやYAMLなどのファイルで管理して読み込んでください。
  - データベースに入れるかどうかは、どちらでも構いません。 
- リクエストやレスポンスの形式は、ご自由に考えてくださって構いません。
- 同様の料金体系のプランが対象プランに追加された場合も、ロジックを追加せずに済むようにしてください。

## 確認ポイント
以下の内容を特に確認させていただきます。
- Rubyを用いて電気料金の計算を実装できること
- オブジェクト指向の理解度
- 実装に対するアプローチの仕方
- 要求仕様を正しく理解し、実装に反映できること

## 提出形式
1. このRepositoryをForkしてください。
1. `/challenges` 内にご自身のアカウント名でフォルダを作成し、その中に各ファイルを作成してください。
1. このRepositoryへのPull Requestを作成してください。

## +α（余裕がある方のみで結構です）
（ご対応されてなくても、評価がマイナスになることは一切ございません。）
- ユーザーが情報を入力するフォームやフロントエンドからAPIを叩く処理、シミュレーション結果の表示など、関連するフロントエンドの実装もしてください。
  - フロントエンドの技術選定はお任せいたします。
  - デザインやUI/UXは凝らなくて構いません。
  - サンプルデザインが必要な方は、 [frontend_challenge_2のデザインファイル](https://github.com/enechange/coding-challenge/blob/master/frontend_challenge_2/files/design.png)を参考にしてください。
- 作成したAPIやページが実行/閲覧できる環境を、Heroku 等で作成してくださるのが好ましいです。
