import type { Meta, StoryObj } from '@storybook/nextjs';

import { RequiredBadge } from './required-badge';

const meta: Meta<typeof RequiredBadge> = {
    component: RequiredBadge,
};

export default meta;
type Story = StoryObj<typeof RequiredBadge>;

export const Default: Story = {};
