import React from 'react';
import { Meta, Story } from '@storybook/react';
import { action } from '@storybook/addon-actions';

import FormTemplate, { Props } from './FormTemplate';

export default {
  title: 'challenge/templates/FormTemplate',
  component: FormTemplate,
} as Meta;

const Template: Story<Props> = (args) => (
  <FormTemplate
    {...args}
    handleCode={action('handleCode')}
    openDialog={action('openDialog')}
    handleCost={action('handleCost')}
    handleSend={action('handleSend')}
  />
);

export const Default = Template.bind({});
Default.args = {
  code: ['123', '4567'],
  corpId: undefined,
  planId: undefined,
  capId: undefined,
  cost: 5000,
};
