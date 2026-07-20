import type { Meta, StoryObj } from '@storybook/nextjs';

import { ErrorMessage } from './error';

const meta: Meta<typeof ErrorMessage> = {
    component: ErrorMessage,
    args: {
        children: 'エラーメッセージを表示するコンポーネント',
    },
};

export default meta;
type Story = StoryObj<typeof ErrorMessage>;

export const Default: Story = {};
