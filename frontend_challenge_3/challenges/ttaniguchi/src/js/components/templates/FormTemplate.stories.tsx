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
  corp: '東京電力',
  plan: ['従量電灯C', '東京電力の従量電灯Cプランです'],
  cap: 49,
  cost: 5000,
};
