import React from 'react';
import { Meta, Story } from '@storybook/react';

import Title, { Props } from './Title';

export default {
  title: 'challenge/atoms/Title',
  component: Title,
} as Meta;

const Template: Story<Props> = (args) => <Title>{args.children}</Title>;

export const Default = Template.bind({});
Default.args = {
  children: '郵便番号をご入力ください',
};
