import { zodResolver } from '@hookform/resolvers/zod';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { http, HttpResponse } from 'msw';
import { FormProvider, useForm, useWatch } from 'react-hook-form';
import { describe, expect, it } from 'vitest';

import { server } from '@/testing/msw/server';

import {
    simulationFormSchema,
    type SimulationFormInput,
    type SimulationFormOutput,
} from '../schemas/simulation-form-schema';

import { ZipCodeField } from './zip-code-field';

const defaultValues: SimulationFormInput = {
    zipCode: '',
    areaId: null,
    providerId: null,
    planId: null,
    capacityValue: null,
    electricityBill: '',
    email: '',
};

// areaId は ZipCodeField 自身は描画しないため、テストから観測できるよう
// フォーム値を可視化するプローブを併置する
function AreaIdProbe() {
    const areaId = useWatch<SimulationFormInput, 'areaId'>({
        name: 'areaId',
    });
    return <span data-testid="area-id">{areaId ?? 'null'}</span>;
}

function TestForm() {
    const form = useForm<SimulationFormInput, unknown, SimulationFormOutput>({
        resolver: zodResolver(simulationFormSchema),
        mode: 'onChange',
        defaultValues,
    });
    return (
        <FormProvider {...form}>
            <ZipCodeField />
            <AreaIdProbe />
        </FormProvider>
    );
}

async function fillZipCode(
    user: ReturnType<typeof userEvent.setup>,
    prefix: string,
    suffix: string,
) {
    await user.type(screen.getByPlaceholderText('130'), prefix);
    await user.type(
        screen.getByLabelText('電気を使用する場所の郵便番号（下4桁）'),
        suffix,
    );
}

describe('ZipCodeField', () => {
    it('サービスエリア対象外の郵便番号では「サービスエリア対象外です。」を表示する', async () => {
        const user = userEvent.setup();
        render(<TestForm />);

        await fillZipCode(user, '000', '0000');

        expect(await screen.findByRole('alert')).toHaveTextContent(
            'サービスエリア対象外です。',
        );
    });

    it('通信エラー時は「通信エラーが発生しました。時間をおいて再度お試しください。」を表示する', async () => {
        server.use(
            http.post('/api/check-service-area', () => HttpResponse.error()),
        );
        const user = userEvent.setup();
        render(<TestForm />);

        await fillZipCode(user, '130', '0012');

        expect(await screen.findByRole('alert')).toHaveTextContent(
            '通信エラーが発生しました。時間をおいて再度お試しください。',
        );
    });

    it('確定済みのareaIdは、郵便番号を7桁未満に編集すると失効する', async () => {
        const user = userEvent.setup();
        render(<TestForm />);

        await fillZipCode(user, '130', '0012');
        expect(await screen.findByTestId('area-id')).toHaveTextContent('tokyo');

        await user.type(
            screen.getByLabelText('電気を使用する場所の郵便番号（下4桁）'),
            '{backspace}',
        );

        expect(screen.getByTestId('area-id')).toHaveTextContent('null');
    });
});
