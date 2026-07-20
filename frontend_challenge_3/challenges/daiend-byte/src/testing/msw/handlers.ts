import { http, HttpResponse } from 'msw';

// 本番のRoute Handler（app/api/check-service-area/route.ts）と同じ判定ロジックを
// テスト用に再現する（ADR-0006/ADR-0014）。checkServiceArea側の実装は変更しない
function resolveAreaId(zipCode: string): 'tokyo' | 'kansai' | null {
    switch (zipCode.charAt(0)) {
        case '1':
            return 'tokyo';
        case '5':
            return 'kansai';
        default:
            return null;
    }
}

export const handlers = [
    http.post('/api/check-service-area', async ({ request }) => {
        const body = (await request.json()) as { zipCode: string };
        return HttpResponse.json({ areaId: resolveAreaId(body.zipCode) });
    }),
];
