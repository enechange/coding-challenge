import type { Meta, StoryObj } from '@storybook/nextjs';

import { SectionCard } from './section-card';

const meta: Meta<typeof SectionCard> = {
    component: SectionCard,
    args: {
        heading: '郵便番号をご入力ください',
        children: (
            <p className="text-sm text-text">
                本文コンテンツを表示するコンポーネント
            </p>
        ),
    },
    decorators: [
        (Story) => (
            <div className="bg-background p-4">
                <Story />
            </div>
        ),
    ],
};

export default meta;
type Story = StoryObj<typeof SectionCard>;

export const Default: Story = {};
