import React from 'react';
import { Meta, Story } from '@storybook/react';

import Label, { Props } from './Label';

export default {
  title: 'challenge/atoms/Label',
  component: Label,
} as Meta;

const Template: Story<Props> = (args) => (
  <Label {...args} />
);

export const Default = Template.bind({});
Default.args = {
  label: 'label',
};
