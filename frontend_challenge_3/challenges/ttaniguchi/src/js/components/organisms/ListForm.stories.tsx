import React from 'react';
import { Meta, Story } from '@storybook/react';
import { action } from '@storybook/addon-actions';
import { DummyList } from '@/js/types/List';

import ListForm, { Props } from './ListForm';

export default {
  title: 'challenge/organisms/ListForm',
  component: ListForm,
} as Meta;

const Template: Story<Props> = (args) => (
  <ListForm {...args} onSelect={action('onSelect')} />
);

export const Default = Template.bind({});
Default.args = {
  list: DummyList,
  selected: 1,
};
