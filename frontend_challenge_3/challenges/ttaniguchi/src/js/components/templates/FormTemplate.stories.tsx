import React from 'react';
import { Meta, Story } from '@storybook/react';

import FormTemplate from './FormTemplate';

export default {
  title: 'challenge/templates/FormTemplate',
  component: FormTemplate,
} as Meta;

const Template: Story = (args) => <FormTemplate {...args} />;

export const Default = Template.bind({});
