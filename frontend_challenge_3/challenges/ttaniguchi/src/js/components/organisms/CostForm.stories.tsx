import React from 'react';
import { Meta, Story } from '@storybook/react';

import CostForm, { Props } from './CostForm';

export default {
  title: 'challenge/organisms/CostForm',
  component: CostForm,
} as Meta;

const Template: Story<Props> = (args) => <CostForm {...args} />;

export const Default = Template.bind({});
Default.args = {
  cost: 5000,
};
export const Error = Template.bind({});
Error.args = {
  cost: 999,
  error: 'エラーメッセージを表示するコンポーネント',
};
