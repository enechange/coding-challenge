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

// 東京電力プラン
export const tokyoPlans: SelectOptions = [
  {
    value: "東京電力従量電灯B",
    text:  "従量電灯B"
  },
  {
    value: "東京電力従量電灯C",
    text:  "従量電灯C"
  },
]

// 関西電力プラン
export const kansaiPlans: SelectOptions = [
  {
    value: "関西電力従量電灯A",
    text:  "従量電灯A"
  },
  {
    value: "関西電力従量電灯B",
    text:  "従量電灯B"
  },
]

// 契約容量1
export const capacityOptions1: SelectOptions = [
  { value: "10A" },
  { value: "15A" },
  { value: "20A" },
  { value: "30A" },
  { value: "40A" },
  { value: "50A" },
  { value: "60A" },
]

// 契約容量2 ( 6kVAから49kVAまで1kVA刻み )
export const capacityOptions2: SelectOptions = (() => {
  const result: SelectOptions = []

  for (let i = 6; i <= 49; i++) {
    result.push({ value: i + "kVa" })
  }

  return result
})()
