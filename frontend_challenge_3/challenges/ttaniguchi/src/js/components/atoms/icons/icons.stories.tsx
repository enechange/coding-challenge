import React from 'react';
import { Meta, Story } from '@storybook/react';
import { IconProps } from '@/js/types/Icon';

import Warning from './Warning';

export default {
  title: 'challenge/atoms/icons',
} as Meta;

const Template: Story<IconProps> = (args) => (
  <>
    <Warning {...args} />
  </>
);

export const Default = Template.bind({});
