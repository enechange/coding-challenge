import type { Meta, StoryObj } from '@storybook/nextjs';

import { HelpText } from './help-text';

const meta: Meta<typeof HelpText> = {
    component: HelpText,
    args: {
        children: '選択肢の説明文を表示するコンポーネント',
    },
    render: (args) => (
        <div>
            <div className="w-full rounded-t-sm border-3 border-border bg-surface px-3 py-2 text-sm text-text">
                入力欄（例）
            </div>
            <HelpText {...args} />
        </div>
    ),
};

export default meta;
type Story = StoryObj<typeof HelpText>;

export const Default: Story = {};
