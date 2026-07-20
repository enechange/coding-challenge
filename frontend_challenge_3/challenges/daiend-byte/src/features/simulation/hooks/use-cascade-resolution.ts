'use client';

import type { Control } from 'react-hook-form';
import { useWatch } from 'react-hook-form';

import { getPlan, getProvider } from '../data/selectors';
import type {
    SimulationFormInput,
    SimulationFormOutput,
} from '../schemas/simulation-form-schema';

// 郵便番号→エリア確定→電力会社→プラン→契約容量、というカスケードが
// どこまで解決しているかをマスタデータ突き合わせで判定する。
// 呼び出し元（simulation-page.tsx）が保持する useForm() の control を受け取る
export function useCascadeResolution(
    control: Control<SimulationFormInput, unknown, SimulationFormOutput>,
) {
    const [areaId, providerId, planId, capacityValue] = useWatch({
        control,
        name: ['areaId', 'providerId', 'planId', 'capacityValue'],
    });

    const provider =
        areaId && providerId ? getProvider(areaId, providerId) : undefined;
    const plan = provider && planId ? getPlan(provider, planId) : undefined;
    // 契約容量を聴取しないプラン（関西電力従量電灯A等）ではプラン確定時点で、
    // それ以外のプランでは契約容量確定時点で「電気使用状況」以降が出そろう。
    const isPlanResolved =
        !!plan &&
        (plan.capacities === null ||
            (capacityValue !== null &&
                plan.capacities.includes(capacityValue)));

    return { areaId, isPlanResolved };
}
