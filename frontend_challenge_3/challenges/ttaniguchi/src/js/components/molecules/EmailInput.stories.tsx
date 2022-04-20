import React from 'react';
import { Meta, Story } from '@storybook/react';

import EmailInput, { Props } from './EmailInput';

export default {
  title: 'challenge/molecules/EmailInput',
  component: EmailInput,
} as Meta;

const Template: Story<Props> = (args) => <EmailInput {...args} />;

export const Default = Template.bind({});
Default.args = {
  email: 'test@example.com',
};
export const Disabled = Template.bind({});
Disabled.args = {
  email: 'test@example.com',
  disabled: true,
};
