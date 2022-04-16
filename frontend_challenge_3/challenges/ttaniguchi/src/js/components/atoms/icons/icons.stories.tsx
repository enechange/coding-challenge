import React from 'react';
import { Meta, Story } from '@storybook/react';
import { IconProps } from '@/js/types/Icon';

import CircleArrow from './CircleArrow';
import More from './More';
import Warning from './Warning';

export default {
  title: 'challenge/atoms/icons',
} as Meta;

const Template: Story<IconProps> = (args) => (
  <>
    <CircleArrow {...args} />
    <More {...args} />
    <Warning {...args} />
  </>
);

export const Default = Template.bind({});
