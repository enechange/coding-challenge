import * as z from 'zod';

import {
    MIN_ELECTRICITY_BILL,
    SIMULATION_NOT_SUPPORTED_MESSAGE,
} from '../data/constants';
import { getPlan, getProvider } from '../data/selectors';

export const simulationFormSchema = z
    .object({
        zipCode: z.string().regex(/^\d{7}$/, {
            message: '郵便番号を正しく入力してください。',
        }),
        // zip-code-field.tsx の onBlur で checkServiceArea の結果をセットする（ADR-0006）
        areaId: z.enum(['tokyo', 'kansai']).nullable(),
        providerId: z.string().min(1).nullable(),
        planId: z.string().min(1).nullable(),
        capacityValue: z.string().min(1).nullable(),
        // z.coerce.number()の.min()メッセージは数値への変換に成功した場合のみ
        // 使われ、数値以外の入力は型チェックの既定メッセージになってしまうため、
        // 文字列のrefineで数値判定・最低料金判定を一括して行い、メッセージを一本化する
        electricityBill: z
            .string()
            .refine(
                (value) => {
                    const parsed = Number(value);
                    return (
                        !Number.isNaN(parsed) && parsed >= MIN_ELECTRICITY_BILL
                    );
                },
                { message: '電気代を正しく入力してください。' },
            )
            .transform((value) => Number(value)),
        email: z
            .email({ message: 'メールアドレスを正しく入力してください。' })
            .regex(/.+@.+\..+/, {
                message: 'メールアドレスを正しく入力してください。',
            }),
    })
    .superRefine((data, ctx) => {
        // zipCode自体の形式エラーはフィールドレベルのregexが担当するため、
        // ここでは形式が正しい場合のみカスケード整合性を検証する
        if (!/^\d{7}$/.test(data.zipCode)) {
            return;
        }

        if (data.areaId === null) {
            ctx.addIssue({
                code: 'custom',
                message: 'サービスエリア対象外です。',
                path: ['areaId'],
            });
            return;
        }

        const provider = data.providerId
            ? getProvider(data.areaId, data.providerId)
            : undefined;
        if (!provider) {
            ctx.addIssue({
                code: 'custom',
                message: '電力会社を選択してください。',
                path: ['providerId'],
            });
            return;
        }
        if (provider.plans === null) {
            ctx.addIssue({
                code: 'custom',
                message: SIMULATION_NOT_SUPPORTED_MESSAGE,
                path: ['providerId'],
            });
            return;
        }

        const plan = data.planId ? getPlan(provider, data.planId) : undefined;
        if (!plan) {
            ctx.addIssue({
                code: 'custom',
                message: 'プランを選択してください。',
                path: ['planId'],
            });
            return;
        }

        if (
            plan.capacities !== null &&
            (data.capacityValue === null ||
                !plan.capacities.includes(data.capacityValue))
        ) {
            ctx.addIssue({
                code: 'custom',
                message: '契約容量を選択してください。',
                path: ['capacityValue'],
            });
        }
    });

export type SimulationFormInput = z.input<typeof simulationFormSchema>;
export type SimulationFormOutput = z.output<typeof simulationFormSchema>;
