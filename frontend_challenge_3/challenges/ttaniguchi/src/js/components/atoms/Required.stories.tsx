import React from 'react';
import { Meta, Story } from '@storybook/react';

import Required from './Required';

export default {
  title: 'challenge/atoms/Required',
  component: Required,
} as Meta;

const Template: Story = (args) => <Required {...args} />;

export const Default = Template.bind({});
