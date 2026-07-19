import type { Meta, StoryObj } from '@storybook/nextjs';

import { Select } from './select';

const meta: Meta<typeof Select> = {
    component: Select,
    args: {
        label: '電力会社',
        options: [
            { label: '東京電力エナジーパートナー', value: 'tepco' },
            { label: 'その他', value: 'other-tokyo' },
        ],
    },
};

export default meta;
type Story = StoryObj<typeof Select>;

export const Default: Story = {};

export const Required: Story = {
    args: { required: true },
};

export const WithHelpText: Story = {
    args: {
        required: true,
        helpText: '選択肢の説明文を表示するコンポーネント',
    },
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
