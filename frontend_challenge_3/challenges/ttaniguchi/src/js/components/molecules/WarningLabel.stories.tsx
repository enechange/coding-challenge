import React from 'react';
import { Meta, Story } from '@storybook/react';

import WarningLabel from './WarningLabel';

export default {
  title: 'challenge/molecules/WarningLabel',
  component: WarningLabel,
} as Meta;

const Template: Story = (args) => <WarningLabel {...args} />;

export const Default = Template.bind({});
Default.args = {
  children: 'エラーメッセージを表示するコンポーネント',
};
