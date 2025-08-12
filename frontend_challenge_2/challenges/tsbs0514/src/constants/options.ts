import type {
  PowerArea,
  PowerCompany,
  ElectricPlan,
  ContractCapacity,
} from "@/types";

// 共通のOption型（UIに依存しない）
export type LabeledOption<V extends string> = { value: V; label: string };

// 電力会社の選択肢（エリア別）
export const COMPANY_OPTIONS_TOKYO: ReadonlyArray<LabeledOption<PowerCompany>> =
  [
    { value: "tokyo-electric", label: "東京電力" },
    { value: "other", label: "その他" },
  ] as const;

export const COMPANY_OPTIONS_KANSAI: ReadonlyArray<
  LabeledOption<PowerCompany>
> = [
  { value: "kansai-electric", label: "関西電力" },
  { value: "other", label: "その他" },
] as const;

export const COMPANY_OPTIONS_BY_AREA: Readonly<
  Record<
    Exclude<PowerArea, "out-of-service">,
    ReadonlyArray<LabeledOption<PowerCompany>>
  >
> = {
  tokyo: COMPANY_OPTIONS_TOKYO,
  kansai: COMPANY_OPTIONS_KANSAI,
} as const;

// プランの選択肢
export interface PlanOption {
  value: ElectricPlan;
  label: string;
  description: string;
}

export const TOKYO_PLANS: ReadonlyArray<PlanOption> = [
  {
    value: "tokyo-juryou-b",
    label: "従量電灯B",
    description:
      "戸建・ファミリー向けの標準プラン。10A〜60Aの契約容量に応じた基本料金と、使用量に応じた従量料金で構成されます。夜間の使用が少ないご家庭におすすめです。",
  },
  {
    value: "tokyo-juryou-c",
    label: "従量電灯C",
    description:
      "高使用量世帯・小規模事業者向けのプラン。6〜49kVAで契約し、基本料金は契約kVAごとに設定されます。季節や時間帯による単価変動はなく通年で安定した料金設計です。",
  },
] as const;

export const KANSAI_PLANS: ReadonlyArray<PlanOption> = [
  {
    value: "kansai-juryou-a",
    label: "従量電灯A",
    description:
      "契約容量の設定が不要な標準プラン。使用量に応じて段階的に単価が変わります。ワンルームや電力使用が少なめの世帯に適しています。",
  },
  {
    value: "kansai-juryou-b",
    label: "従量電灯B",
    description:
      "高使用量世帯・業務利用向けのプラン。6〜49kVAで契約し、基本料金＋従量料金で構成されます。昼間の使用が多い場合に有利になるケースがあります。",
  },
] as const;

// 契約容量の選択肢
export type CapacityOption = { value: ContractCapacity; label: string };

export const TOKYO_JURYOU_B_CAPACITY_OPTIONS: ReadonlyArray<CapacityOption> = [
  "10A",
  "15A",
  "20A",
  "30A",
  "40A",
  "50A",
  "60A",
].map((amp) => ({ value: amp as ContractCapacity, label: amp }));

export const KVA_CAPACITY_OPTIONS: ReadonlyArray<CapacityOption> = Array.from(
  { length: 44 },
  (_, i) => {
    const kva = i + 6;
    const label = `${kva}kVA`;
    return { value: label as ContractCapacity, label };
  }
);

export const PLAN_TO_CAPACITIES: Readonly<
  Record<Exclude<ElectricPlan, "">, ReadonlyArray<CapacityOption>>
> = {
  "tokyo-juryou-b": TOKYO_JURYOU_B_CAPACITY_OPTIONS,
  "tokyo-juryou-c": KVA_CAPACITY_OPTIONS,
  "kansai-juryou-a": [],
  "kansai-juryou-b": KVA_CAPACITY_OPTIONS,
} as const;

// 表示用のラベルマップ
export const POWER_COMPANY_LABELS: Readonly<
  Record<Exclude<PowerCompany, "">, string>
> = {
  "tokyo-electric": "東京電力",
  "kansai-electric": "関西電力",
  other: "その他",
} as const;

export const PLAN_LABELS: Readonly<Record<Exclude<ElectricPlan, "">, string>> =
  {
    "tokyo-juryou-b": "従量電灯B",
    "tokyo-juryou-c": "従量電灯C",
    "kansai-juryou-a": "従量電灯A",
    "kansai-juryou-b": "従量電灯B",
  } as const;
