import type { Meta, StoryObj } from '@storybook/nextjs';

import { Button } from './button';

const meta: Meta<typeof Button> = {
    component: Button,
    args: {
        type: 'button',
        children: '結果を見る',
    },
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Default: Story = {};

export const Disabled: Story = {
    args: { disabled: true },
};
