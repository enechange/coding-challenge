# ADR-0016: 対応ブラウザ方針（IE11 対象外）

## Status

Accepted

## Context

README には当初「主要ブラウザの最新版を対象とする。ただし IE11 では見た目が崩れていることを許容するが、JavaScript が動作しシミュレーションが完遂できれば問題ない」と記載されていた。

一方で技術選定（[ADR-0002](./0002-nextjs-app-router.md) Next.js App Router 採用）により、ビルド・実行基盤は React Server Components を含むモダンな Next.js App Router に確定している。Next.js は v13 以降 IE11 向けのレガシートランスパイル機構を廃止しており、公式に IE11 をサポート対象外としている。IE11 で「JS が動作しシミュレーションが完遂できる」水準を満たすには、browserslist 経由の追加トランスパイル設定や手動 polyfill の導入が必要になり、Next.js の標準的な開発体験から外れたカスタマイズが発生する。

この状況を踏まえ、課題の依頼元に確認したところ、IE11 対応は不要という回答を得た。

## Decision

IE11 を対応対象から除外する。対象ブラウザは主要ブラウザ（Chrome / Edge / Firefox / Safari）の最新版のみとし、Next.js のデフォルトの browserslist 設定（モダンブラウザ向け）をそのまま採用する。IE11 向けの polyfill・トランスパイル設定・動作確認は行わない。

根拠:

- Next.js App Router は IE11 を公式サポート対象外としており、対応には標準構成から外れるカスタマイズが必要
- 課題の依頼元から IE11 対応不要の明示的な確認を得ており、README記載時点の制約は本課題においては適用されない
- 対象を絞ることで、ビルド設定・実装の複雑さを抑え、レビュー対象コードをシンプルに保てる

## Consequences

- 正: browserslist・polyfill・IE11向けCSSフォールバックの実装が不要になり、ビルド設定・実装がシンプルに保たれる
- 負: なし（依頼元確認済みのため実質的な制約緩和）
