import React from 'react';
import { Meta, Story } from '@storybook/react';

import CostInput, { Props } from './CostInput';

export default {
  title: 'challenge/molecules/CostInput',
  component: CostInput,
} as Meta;

const Template: Story<Props> = (args) => <CostInput {...args} />;

export const Default = Template.bind({});
Default.args = {
  cost: 5000,
};
export const Disabled = Template.bind({});
Disabled.args = {
  cost: 5000,
  disabled: true,
};
