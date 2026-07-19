import type { Meta, StoryObj } from '@storybook/nextjs';

import { FieldWrapper } from './field-wrapper';

const meta: Meta<typeof FieldWrapper> = {
    component: FieldWrapper,
    args: {
        label: 'ラベル',
        htmlFor: 'field-wrapper-story-input',
        children: (
            <input
                id="field-wrapper-story-input"
                className="w-full rounded-sm border-3 border-border bg-surface px-3 py-2 text-sm text-text"
                placeholder="プレースホルダー"
            />
        ),
    },
};

export default meta;
type Story = StoryObj<typeof FieldWrapper>;

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

export const WithHelpText: Story = {
    args: {
        helpText: '選択肢の説明文を表示するコンポーネント',
        children: (
            <input
                id="field-wrapper-story-input"
                className="w-full rounded-t-sm border-3 border-border bg-surface px-3 py-2 text-sm text-text"
                placeholder="プレースホルダー"
            />
        ),
    },
};
