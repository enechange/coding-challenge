export const POSTAL_CODES_BY_AREA = { 1: 'tokyo', 5: 'kansai'};

const CAPACITY_TYPE1 = ['10A', '15A', '20A', '30A', '40A', '50A', '60A'];
const CAPACITY_TYPE2 = []; //6~49
for (let i = 6; i < 50; i++) {
  CAPACITY_TYPE2.push(`${i}kVA`);
};

const TEPCO_PLANS = [
  { id: 'tepco-plan-1', name: '従量電灯B', description: '従量電灯Bの説明文が入ります', capacity: CAPACITY_TYPE1 },
  { id: 'tepco-plan-2', name: '従量電灯C', description: '従量電灯Cの説明文が入ります', capacity: CAPACITY_TYPE2 },
];

const KEPCO_PLANS = [
  { id: 'kepco-plan-1', name: '従量電灯A', description: '契約容量の選択は不要です', capacity: [] },
  { id: 'kepco-plan-2', name: '従量電灯B', description: '従量電灯Bの説明文が入ります', capacity: CAPACITY_TYPE2 },
];

export const COMPANIES_BY_AREA = {
  tokyo: [{ id: 'tepco', name: '東京電力', plans: TEPCO_PLANS }, { id: 'other', name: 'その他', plans: undefined }],
  kansai: [{ id: 'kepco',name: '関西電力', plans: KEPCO_PLANS }, { id: 'other', name: 'その他', plans: undefined }],
};
