import type { Meta, StoryObj } from '@storybook/nextjs';

import { SectionHeading } from './section-heading';

const meta: Meta<typeof SectionHeading> = {
    component: SectionHeading,
    args: {
        children: '郵便番号をご入力ください',
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
type Story = StoryObj<typeof SectionHeading>;

export const Default: Story = {};
