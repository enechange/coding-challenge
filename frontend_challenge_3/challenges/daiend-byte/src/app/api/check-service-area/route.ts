import { NextResponse } from 'next/server';
import * as z from 'zod';

import type { AreaId } from '@/features/simulation/data/types';

const requestSchema = z.object({ zipCode: z.string() });

// 仮実装（README仕様）: 郵便番号の上1桁でエリアを判定する。
// サーバーサイド実装完了後はこのRoute Handlerごと削除する（ADR-0006）。
function resolveAreaId(zipCode: string): AreaId | null {
    switch (zipCode.charAt(0)) {
        case '1':
            return 'tokyo';
        case '5':
            return 'kansai';
        default:
            return null;
    }
}

export async function POST(request: Request) {
    const body: unknown = await request.json().catch(() => null);
    const parsed = requestSchema.safeParse(body);

    if (!parsed.success) {
        return NextResponse.json(
            { error: 'リクエスト形式が正しくありません。' },
            { status: 400 },
        );
    }

    return NextResponse.json({
        areaId: resolveAreaId(parsed.data.zipCode),
    });
}
