# coding-challenge

## 環境構築とコンパイル
### 環境構築
Node.js 10.15.3 にて動作確認しております。
`_dev` ディレクトリで下記コマンドを実行してください。

    npm i

### コンパイル
#### ファイル変更の監視とビルド
ファイル変更のたびにビルドを実行します。
このディレクトリにコンパイル後のHTML/CSS/JSを書き出します。  
また、このディレクトリをルートにローカルサーバを立ち上げます。 `http://localhost:4008/` をブラウザで開くことでプレビュー可能です。実機確認の際はローカルIPアドレスを直接指定すればブラウザで表示できます。
ファイルの変更は基本的に `_dev` ディレクトリ以下でのみ行い、コンパイル後のファイルは触りません。

`_dev` ディレクトリで下記コマンドを実行してください。

    npm run start

#### 画像の圧縮
自動実行すると処理が重いため、画像を追加した際は逐次圧縮を行う必要があります。
todo: npm script に入れておくほうが良いか
`_dev` ディレクトリで下記コマンドを実行してください。

    npx gulp imgmin

### プレビュー
`index.html` をブラウザで開くか、上記の「ファイル変更の監視」のとおりに操作してください。

## コーディング

### HTML
記述の簡略化と構文エラー防止のため、[Pug](https://pugjs.org/)を使用しています。
インデント記法であれば、divが多用されがちなマークアップにおいてもタグの閉じ忘れによる構文エラーを予防できます。

### CSS
プリプロセッサにはSCSSを使用し、CSSを実ファイルで書き出します。
todo: 後からVueを入れてしまったのでscopedになっていない
命名規則は[FLOCSS](https://github.com/hiloki/flocss)をベースに、[ECSS](https://ecss.io)のエッセンスを取り入れています。
下記のようにクラス名を指定します。

    .l-Layout（レイアウト）
    .c-Component（コンポーネント。コンポーネント単位でファイル分割）
    .p-Project（プロジェクト。おもにページ固有のパターン。セクションやページの単位でファイル分割）
    .u-Utility（ユーティリティ。手間を省くための調整用クラスなのでみだりに作ってはいけない）
    .t-Type（タイプ。他のクラスに追加してModifierとして使用する）
    .is-State（JS等で操作された状態を示す）

チェックは[stylelint-config-standard](https://github.com/stylelint/stylelint-config-standard)をベースとしています。

### JavaScript
フォームではフレームワークに[Vue](https://jp.vuejs.org/index.html)を使用し、内部のHTMLテンプレートをPugで記述しています。
それ以外ではjQuery 3.xを使用しています。
コーディングルールは[semistandard](https://github.com/Flet/semistandard)をベースにしています。
その上で、Vueの記法とのバッティング回避、自動フォーマットの使用のため、ESLintにpluginの追加を行っています。
