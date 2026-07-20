import { describe, expect, it } from 'vitest';

import { generateKvaRange } from './master-data';

describe('generateKvaRange', () => {
    it('fromからtoまでの要素数を持つ配列を生成する', () => {
        expect(generateKvaRange(6, 49)).toHaveLength(44);
    });

    it('境界値（下限・上限）を含む', () => {
        const result = generateKvaRange(6, 49);
        expect(result[0]).toBe('6kVA');
        expect(result.at(-1)).toBe('49kVA');
    });
});
