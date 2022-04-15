import React from 'react';
import { Meta, Story } from '@storybook/react';

import PostalInput, { Props } from './PostalInput';

export default {
  title: 'challenge/molecules/PostalInput',
  component: PostalInput,
} as Meta;

const Template: Story<Props> = (args) => <PostalInput {...args} />;

export const Default = Template.bind({});
Default.args = {
  code: ['107', '0011'],
};
