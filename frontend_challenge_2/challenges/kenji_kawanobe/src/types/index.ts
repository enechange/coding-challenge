/** エリアタイプ */
export enum areaTypes {
  TOKYO = "東京エリア",
  KANSAI = "関西エリア",
  OTHER = "対象外エリア",
}

/** 会社 */
export enum companyTypes {
  TOKYO_DENRYOKU = "東京電力",
  KANSAI_DENRYOKU = "関西電力",
  OTHER = "その他",
  UNSELECTED = "",
}

/** プラン */
export enum planTypes {
  PLAN_A = "従量電灯A",
  PLAN_B = "従量電灯B",
  PLAN_C = "従量電灯C",
  UNSELECTED = "",
}

/** シミュレーションデータ(入力) */
export interface ISimulation {
  /** 郵便番号(前半) */
  firstZipCode: string;
  /** 郵便番号(後半) */
  secondZipCode: string;
  /** 会社 */
  company: companyTypes;
  /** プラン */
  plan: planTypes;
  /** 契約容量 */
  amps: string;
  /** 支払金額 */
  pay: string | number;
  /** メールアドレス */
  email: string;
}

// リクエスト(結果を見る押下)時の型定義
export interface Simulation {
  /** 郵便番号 */
  zipCode: string;
  /** 会社 */
  company: companyTypes;
  /** プラン */
  plan: planTypes;
  /** 契約容量 */
  amps: string;
  /** 支払金額 */
  pay: number;
  /** メールアドレス */
  email: string;
}

/** セレクタオプションの型定義 */
export interface SelectOption {
  /** 値 */
  value: string;
  /** ラベル文言 */
  label: string;
  /** 選択状態 */
  selected?: boolean;
}
