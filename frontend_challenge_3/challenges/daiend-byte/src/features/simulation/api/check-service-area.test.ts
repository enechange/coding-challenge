import { describe, expect, it } from 'vitest';

import { checkServiceArea } from './check-service-area';

describe('checkServiceArea', () => {
    it.each([
        ['1300012', 'tokyo'],
        ['5300001', 'kansai'],
        ['0000000', null],
        ['9999999', null],
    ] as const)('先頭が%sのとき%sを返す', async (zipCode, expected) => {
        await expect(checkServiceArea(zipCode)).resolves.toBe(expected);
    });
});
