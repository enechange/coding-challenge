import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';

import { SimulationPage } from './simulation-page';

describe('SimulationPage', () => {
    it('郵便番号入力→エリア確定→電力会社/プラン/契約容量の出現が連動する', async () => {
        const user = userEvent.setup();
        render(<SimulationPage />);

        await user.type(screen.getByPlaceholderText('130'), '130');
        await user.type(
            screen.getByLabelText('電気を使用する場所の郵便番号（下4桁）'),
            '0012',
        );

        const providerSelect = await screen.findByRole('combobox', {
            name: /電力会社/,
        });
        await user.selectOptions(providerSelect, '東京電力');

        const planSelect = await screen.findByRole('combobox', {
            name: /プラン/,
        });
        await user.selectOptions(planSelect, '従量電灯B');

        const capacitySelect = await screen.findByRole('combobox', {
            name: /契約容量/,
        });
        await user.selectOptions(capacitySelect, '10A');

        expect(
            await screen.findByLabelText(/先月の電気代は？/),
        ).toBeInTheDocument();
    });
});
