import { z } from 'zod';

import type { AreaId } from '../data/types';

const responseSchema = z.object({
    areaId: z.enum(['tokyo', 'kansai']).nullable(),
});

export async function checkServiceArea(
    zipCode: string,
): Promise<AreaId | null> {
    const res = await fetch('/api/check-service-area', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ zipCode }),
    });

    if (!res.ok) {
        throw new Error('サービスエリア判定に失敗しました。');
    }

    const data: unknown = await res.json();
    return responseSchema.parse(data).areaId;
}
