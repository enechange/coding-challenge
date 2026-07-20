import type { Area, AreaId } from './types';

function generateKvaRange(from: number, to: number): string[] {
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
                        description: null,
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
                        description: null,
                        capacities: generateKvaRange(6, 49),
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
                        description: null,
                        capacities: null,
                    },
                    {
                        id: 'kepco-juryou-b',
                        name: '従量電灯B',
                        description: null,
                        capacities: generateKvaRange(6, 49),
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
