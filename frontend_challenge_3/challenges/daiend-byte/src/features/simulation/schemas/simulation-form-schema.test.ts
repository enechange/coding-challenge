import { describe, expect, it } from 'vitest';

import {
    simulationFormSchema,
    type SimulationFormInput,
} from './simulation-form-schema';

// カスケード上有効な組み合わせ（東京電力エリア/東京電力/従量電灯B/10A）を基準値とし、
// 各テストで検証対象のフィールドだけを差し替える
const validInput: SimulationFormInput = {
    zipCode: '1300012',
    areaId: 'tokyo',
    providerId: 'tepco',
    planId: 'tepco-juryou-b',
    capacityValue: '10A',
    electricityBill: '5000',
    email: 'user@example.com',
};

describe('simulationFormSchema', () => {
    it('カスケード上有効な組み合わせはvalid', () => {
        expect(simulationFormSchema.safeParse(validInput).success).toBe(true);
    });

    describe('electricityBill', () => {
        it('最低料金未満（999）はinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                electricityBill: '999',
            });
            expect(result.success).toBe(false);
            if (!result.success) {
                expect(result.error.issues[0]?.message).toBe(
                    '電気代を正しく入力してください。',
                );
            }
        });

        it('最低料金（1000）はvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                electricityBill: '1000',
            });
            expect(result.success).toBe(true);
        });

        it('数値以外の入力はinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                electricityBill: 'abc',
            });
            expect(result.success).toBe(false);
            if (!result.success) {
                expect(result.error.issues[0]?.message).toBe(
                    '電気代を正しく入力してください。',
                );
            }
        });
    });

    describe('email', () => {
        it('TLDなしはinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                email: 'user@example',
            });
            expect(result.success).toBe(false);
        });

        it('正しい形式はvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                email: 'user@example.com',
            });
            expect(result.success).toBe(true);
        });
    });

    describe('zipCode', () => {
        it('6桁はinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                zipCode: '130001',
            });
            expect(result.success).toBe(false);
        });

        it('8桁はinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                zipCode: '13000123',
            });
            expect(result.success).toBe(false);
        });

        it('7桁数字はvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                zipCode: '1300012',
            });
            expect(result.success).toBe(true);
        });
    });

    describe('カスケード整合性（superRefine）', () => {
        it('東京エリア×関西電力プランの組み合わせはinvalid', () => {
            const result = simulationFormSchema.safeParse({
                ...validInput,
                areaId: 'tokyo',
                providerId: 'kepco',
            });
            expect(result.success).toBe(false);
            if (!result.success) {
                expect(result.error.issues[0]?.path).toEqual(['providerId']);
            }
        });
    });
});
