import { describe, expect, it } from 'vitest';

import { MAX_KVA, MIN_KVA } from './constants';
import { generateKvaRange } from './master-data';

describe('generateKvaRange', () => {
    it('fromからtoまでの要素数を持つ配列を生成する', () => {
        expect(generateKvaRange(MIN_KVA, MAX_KVA)).toHaveLength(44);
    });

    it('境界値（下限・上限）を含む', () => {
        const result = generateKvaRange(MIN_KVA, MAX_KVA);
        expect(result[0]).toBe(`${MIN_KVA.toString()}kVA`);
        expect(result.at(-1)).toBe(`${MAX_KVA.toString()}kVA`);
    });
});
