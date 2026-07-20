import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { useState } from 'react';
import { describe, expect, it } from 'vitest';

import { ZipCodeInput } from './zip-code-input';

function ControlledZipCodeInput({
    initialPrefix = '',
}: {
    initialPrefix?: string;
}) {
    const [prefix, setPrefix] = useState(initialPrefix);
    const [suffix, setSuffix] = useState('');
    return (
        <ZipCodeInput
            label="郵便番号"
            prefixValue={prefix}
            onPrefixChange={setPrefix}
            suffixValue={suffix}
            onSuffixChange={setSuffix}
        />
    );
}

describe('ZipCodeInput', () => {
    it('先頭3桁を末尾まで入力し終えると下4桁欄へフォーカスが移動する', async () => {
        const user = userEvent.setup();
        render(<ControlledZipCodeInput />);

        await user.click(screen.getByPlaceholderText('130'));
        await user.keyboard('130');

        expect(screen.getByLabelText('郵便番号（下4桁）')).toHaveFocus();
    });

    it('既に3桁埋まっている先頭欄の途中の桁を選択して打ち直しても、フォーカスは奪われない', async () => {
        const user = userEvent.setup();
        render(<ControlledZipCodeInput initialPrefix="130" />);
        const prefixInput = screen.getByPlaceholderText('130');

        await user.click(prefixInput);
        await user.keyboard('{Home}{Delete}5');

        expect(prefixInput).toHaveFocus();
    });
});
