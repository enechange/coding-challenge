import React from 'react';
import { action } from '@storybook/addon-actions';
import { Meta, Story } from '@storybook/react';

import ExecButton, { Props } from './ExecButton';

export default {
  title: 'challenge/molecules/ExecButton',
  component: ExecButton,
} as Meta;

const Template: Story<Props> = (args) => (
  <ExecButton {...args} onClick={action('onClick')} />
);

export const Default = Template.bind({});
Default.args = {
  disabled: false,
};
export const Disabled = Template.bind({});
Disabled.args = {
  disabled: true,
};
