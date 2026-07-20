import type { Meta, StoryObj } from '@storybook/nextjs';

import { Input } from './input';

const meta: Meta<typeof Input> = {
    component: Input,
    args: {
        label: 'メールアドレス',
        placeholder: 'メールアドレスを入力してください',
    },
};

export default meta;
type Story = StoryObj<typeof Input>;

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

export const Disabled: Story = {
    args: { disabled: true },
};

export const WithUnit: Story = {
    args: {
        label: '先月の電気代は？',
        placeholder: '5000',
        required: true,
        unit: '円',
    },
};
