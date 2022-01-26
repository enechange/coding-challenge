// セレクトボックスに表示するデータ型の定義
type SelectOption = {
  value: string
  text?: string
}

export type SelectOptions = Array<SelectOption>

// 東京電力エリア
export const tokyoOptions: SelectOptions = [
  { value: "東京電力" },
  { value: "その他" },
]

// 関西電力エリア
export const kansaiOptions: SelectOptions = [
  { value: "関西電力" },
  { value: "その他" },
]
