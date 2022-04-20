import React from 'react';
import { Meta, Story } from '@storybook/react';

import EmailForm, { Props } from './EmailForm';

export default {
  title: 'challenge/organisms/EmailForm',
  component: EmailForm,
} as Meta;

const Template: Story<Props> = (args) => <EmailForm {...args} />;

export const Default = Template.bind({});
Default.args = {
  email: 'test@example.com',
};
export const Error = Template.bind({});
Error.args = {
  email: 'test@example,com',
  error: 'エラーメッセージを表示するコンポーネント',
};
