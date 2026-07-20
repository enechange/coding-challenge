import { MAX_KVA, MIN_KVA } from './constants';
import type { Area, AreaId } from './types';

export function generateKvaRange(from: number, to: number): string[] {
    return Array.from(
        { length: to - from + 1 },
        (_, i) => `${(from + i).toString()}kVA`,
    );
}

export const masterData: Record<AreaId, Area> = {
    tokyo: {
        id: 'tokyo',
        name: '東京電力エリア',
        providers: [
            {
                id: 'tepco',
                name: '東京電力',
                plans: [
                    {
                        id: 'tepco-juryou-b',
                        name: '従量電灯B',
                        description:
                            '高使用量世帯・業務利用向けのプラン。10〜60Aで契約し、基本料金＋従量料金で構成されます。昼間の使用が多い場合に有利になるケースがあります。',
                        capacities: [
                            '10A',
                            '15A',
                            '20A',
                            '30A',
                            '40A',
                            '50A',
                            '60A',
                        ],
                    },
                    {
                        id: 'tepco-juryou-c',
                        name: '従量電灯C',
                        description:
                            '高使用量世帯・小規模事業者向けのプラン。6〜49kVAで契約し、基本料金は契約kVAごとに設定されます。季節や時間帯による単価変動はなく通年で安定した料金設計です。',
                        capacities: generateKvaRange(MIN_KVA, MAX_KVA),
                    },
                ],
            },
            {
                id: 'other-tokyo',
                name: 'その他',
                plans: null,
            },
        ],
    },
    kansai: {
        id: 'kansai',
        name: '関西電力エリア',
        providers: [
            {
                id: 'kepco',
                name: '関西電力',
                plans: [
                    {
                        id: 'kepco-juryou-a',
                        name: '従量電灯A',
                        description:
                            '契約容量の設定が不要な標準プラン。使用量に応じて段階的に単価が変わります。ワンルームや電力使用が少なめの世帯に適しています。',
                        capacities: null,
                    },
                    {
                        id: 'kepco-juryou-b',
                        name: '従量電灯B',
                        description:
                            '高使用量世帯・業務利用向けのプラン。6〜49kVAで契約し、基本料金＋従量料金で構成されます。昼間の使用が多い場合に有利になるケースがあります。',
                        capacities: generateKvaRange(MIN_KVA, MAX_KVA),
                    },
                ],
            },
            {
                id: 'other-kansai',
                name: 'その他',
                plans: null,
            },
        ],
    },
};
