import type { Meta, StoryObj } from '@storybook/nextjs';

import { Reveal } from './reveal';

const meta: Meta<typeof Reveal> = {
    component: Reveal,
    args: {
        children: (
            <div className="bg-surface p-4 text-text">
                マウント時にgrid-template-rowsが0fr→1frへ遷移し出現する
            </div>
        ),
    },
};

export default meta;
type Story = StoryObj<typeof Reveal>;

export const Default: Story = {};
