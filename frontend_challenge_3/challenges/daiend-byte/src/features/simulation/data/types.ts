export type AreaId = 'tokyo' | 'kansai';

export type Area = {
    id: AreaId;
    name: string;
    providers: Provider[];
};

export type Provider = {
    id: string;
    name: string;
    // null: シミュレーション対象外（「その他」等）
    plans: Plan[] | null;
};

export type Plan = {
    id: string;
    name: string;
    description: string | null;
    // null: 契約容量を聴取しない（関西電力 従量電灯A 等）
    capacities: string[] | null;
};
