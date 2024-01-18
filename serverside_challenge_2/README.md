## 課題
ENECHANGEでは各電力会社向けに、電気料金のシミュレーション機能を提供しています。

ユーザーから「契約アンペア数(A)」と「1ヶ月の使用量(kWh)」を受け取って、プランごとの電気料金を返すスクリプトを実装してください。

※要件や実装方法で分からない点がある場合は質問してください。

## 要件
### 基本項目
- 入力値
  - 契約アンペア数 : `10 / 15 / 20 / 30 / 40 / 50 / 60` のいずれかとする。（単位`A`）
  - 1ヶ月の使用量 : 0以上の整数（単位`kWh`）
- 出力値
  - プランごとの電気料金
    ```
    出力例（priceは適当な値になっています）
    [
      { provider_name: 東京電力エナジーパートナー, plan_name: 従量電灯B, price: ‘1234’ },
      { provider_name: ‘Looopでんき’, plan_name: おうちプラン, price: ‘1234’ },
      { provider_name: 東京ガス, plan_name: ずっとも電気1, price: ‘1234’ }, 
      { provider_name: JXTGでんき, plan_name: 従量電灯Bたっぷりプラン, price: ‘1234’ }
    ]  
    ```
- 対象とする 電力会社 / プランは、以下の４つとする。（各料金表は後述）
  - 東京電力エナジーパートナー / 従量電灯B （[参考](http://www.tepco.co.jp/ep/private/plan/old01.html)）
  - Loopでんき / おうちプラン （[参考](https://looop-denki.com/low-v/plan/)）
  - 東京ガス / ずっとも電気1 （[参考](https://home.tokyo-gas.co.jp/power/ryokin/menu_waribiki/menu1.html)）
  - JXTGでんき / 従量電灯Bたっぷりプラン （[参考](https://mydenki.jp/files/plan_tappuri.pdf)）

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
[料金計算方法の詳細](https://www.tepco.co.jp/ep/private/plan2/chargelist04.html#sec03)を参照してください。

#### ③ そのほか
燃料費調整額や再生可能エネルギー賦課金など。今回は考慮しなくて良い。

### 料金表
<img src="https://user-images.githubusercontent.com/1951287/150285118-01b72e4b-93a2-4d57-9e0c-861d60827f60.png" width="400px"> <img src="https://user-images.githubusercontent.com/1951287/150285466-2ef6c23a-f3a9-4123-9c1f-a1b3aed610c2.png" width="400px">
<img src="https://user-images.githubusercontent.com/1951287/150285521-338b0083-b297-4b26-af45-64d8546f0d12.png" width="400px"> <img src="https://user-images.githubusercontent.com/1951287/150285556-c69c2b6e-955a-4769-b64e-1785e4e27d81.png" width="400px">

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