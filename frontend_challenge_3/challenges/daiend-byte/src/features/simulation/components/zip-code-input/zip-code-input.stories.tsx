import type { Meta, StoryObj } from '@storybook/nextjs';

import { ZipCodeInput } from './zip-code-input';

const meta: Meta<typeof ZipCodeInput> = {
    component: ZipCodeInput,
    args: {
        label: '電気を使用する場所の郵便番号',
    },
};

export default meta;
type Story = StoryObj<typeof ZipCodeInput>;

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
