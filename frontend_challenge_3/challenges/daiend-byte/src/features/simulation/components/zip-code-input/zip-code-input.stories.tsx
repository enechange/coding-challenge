import type { Meta, StoryObj } from '@storybook/nextjs';
import { useState } from 'react';

import { ZipCodeInput } from './zip-code-input';

type DemoProps = Omit<
    React.ComponentProps<typeof ZipCodeInput>,
    'prefixValue' | 'suffixValue' | 'onPrefixChange' | 'onSuffixChange'
>;

function ZipCodeInputDemo(props: DemoProps) {
    const [prefix, setPrefix] = useState('130');
    const [suffix, setSuffix] = useState('0012');

    return (
        <ZipCodeInput
            {...props}
            prefixValue={prefix}
            suffixValue={suffix}
            onPrefixChange={setPrefix}
            onSuffixChange={setSuffix}
        />
    );
}

const meta: Meta<typeof ZipCodeInputDemo> = {
    component: ZipCodeInputDemo,
    args: {
        label: '電気を使用する場所の郵便番号',
    },
};

export default meta;
type Story = StoryObj<typeof ZipCodeInputDemo>;

export const Default: Story = {};

export const Required: Story = {
    args: { required: true },
};

export const WithError: Story = {
    args: {
        required: true,
        error: 'エラーメッセージを表示するコンポーネント',
    },
};
