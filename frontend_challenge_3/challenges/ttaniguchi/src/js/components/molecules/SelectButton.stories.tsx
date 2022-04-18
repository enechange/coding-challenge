import React from 'react';
import { action } from '@storybook/addon-actions';
import { Meta, Story } from '@storybook/react';

import SelectButton, { Props } from './SelectButton';

export default {
  title: 'challenge/molecules/SelectButton',
  component: SelectButton,
} as Meta;

const Template: Story<Props> = (args) => (
  <SelectButton {...args} onClick={action('onClick')} />
);

export const Default = Template.bind({});
Default.args = {
  label: '東京電力エナジーパートナー',
};
export const Description = Template.bind({});
Description.args = {
  label: '東京電力エナジーパートナー',
  description: '選択肢の説明文を表示するコンポーネント',
};
export const Disabled = Template.bind({});
Disabled.args = {
  label: '東京電力エナジーパートナー',
  disabled: true,
};
