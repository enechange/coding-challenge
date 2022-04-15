import React from 'react';
import { Meta, Story } from '@storybook/react';

import PostalForm, { Props } from './PostalForm';

export default {
  title: 'challenge/molecules/PostalForm',
  component: PostalForm,
} as Meta;

const Template: Story<Props> = (args) => <PostalForm {...args} />;

export const Default = Template.bind({});
Default.args = {
  code: ['107', '0011'],
};
export const Error = Template.bind({});
Error.args = {
  code: ['107', '0011'],
  error: 'エラーメッセージを表示するコンポーネント',
};
