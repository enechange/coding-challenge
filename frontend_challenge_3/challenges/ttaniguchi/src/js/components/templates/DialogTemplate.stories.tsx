import React from 'react';
import { Meta, Story } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import { DummyList } from '@/js/types/List';

import DialogTemplate, { Props } from './DialogTemplate';

export default {
  title: 'challenge/templates/DialogTemplate',
  component: DialogTemplate,
} as Meta;

const Template: Story<Props> = (args) => (
  <DialogTemplate {...args} onSelect={action('onSelect')} />
);

export const Default = Template.bind({});
Default.args = {
  list: DummyList,
  selected: 1,
};
