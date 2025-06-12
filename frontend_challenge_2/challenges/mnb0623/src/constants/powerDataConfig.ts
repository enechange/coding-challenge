// kVAの選択肢を動的に生成するためのヘルパー関数
const generateKvaOptions = (start: number, end: number) => {
  const options = [];
  for (let i = start; i <= end; i++) {
    const value = `${i}kVA`;
    options.push({ value, label: value });
  }
  return options;
};

// データを一元管理する設定オブジェクト
export const powerDataConfig = {
  tokyo: {
    name: '東京電力',
    plans: {
      meteredPlanB: {
        name: '従量電灯B',
        description: '従量電灯Bのプランの説明',
        // 10Aから60Aまでの固定の選択肢
        capacities: [
          { value: '10A', label: '10A' },
          { value: '15A', label: '15A' },
          { value: '20A', label: '20A' },
          { value: '30A', label: '30A' },
          { value: '40A', label: '40A' },
          { value: '50A', label: '50A' },
          { value: '60A', label: '60A' },
        ],
      },
      meteredPlanC: {
        name: '従量電灯C',
        description: '従量電灯Cのプランの説明',
        // 6kVAから49kVAまでを動的に生成
        capacities: generateKvaOptions(6, 49),
      },
    },
  },
  kansai: {
    name: '関西電力',
    plans: {
      meteredPlanA: {
        name: '従量電灯A',
        description: '従量電灯Aのプランの説明',
        // 関西電力・従量電灯Aは契約容量の聴取が不要なため、空配列にする
        capacities: [],
      },
      meteredPlanB: {
        name: '従量電灯B',
        description: '従量電灯Bのプランの説明',
        // 6kVAから49kVAまでを動的に生成
        capacities: generateKvaOptions(6, 49),
      },
    },
  },
  other: {
    name: 'その他',
    plans: {},
  },
} as const;

export type CompanyKey = keyof typeof powerDataConfig;
export type PlanKey<C extends CompanyKey> =
  keyof (typeof powerDataConfig)[C]['plans'];
export type Capacity = { value: string; label: string };
