import React from 'react';
import { Meta, Story } from '@storybook/react';

import FieldLabel, { Props } from './FieldLabel';

export default {
  title: 'challenge/molecules/FieldLabel',
  component: FieldLabel,
} as Meta;

const Template: Story<Props> = (args) => (
  <FieldLabel>{args.children}</FieldLabel>
);

export const Default = Template.bind({});
Default.args = {
  children: '電気を使用する場所の郵便番号',
};
