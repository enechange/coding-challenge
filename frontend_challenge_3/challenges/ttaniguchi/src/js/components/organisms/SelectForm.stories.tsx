import React from 'react';
import { Meta, Story } from '@storybook/react';
import { action } from '@storybook/addon-actions';

import SelectForm, { Props } from './SelectForm';

export default {
  title: 'challenge/organisms/SelectForm',
  component: SelectForm,
} as Meta;

const Template1: Story<Props> = (args) => <SelectForm {...args} />;

export const Default = Template1.bind({});
Default.args = {
  selectors: [
    {
      name: '電力会社',
      handler: action('handleCorp'),
    },
    {
      name: 'プラン',
      handler: action('handlePlan'),
    },
    {
      name: '契約容量',
      handler: action('handleCap'),
    },
  ],
};
export const Disabled = Template1.bind({});
Disabled.args = {
  selectors: [
    {
      name: '電力会社',
      disabled: true,
      handler: action('handleCorp'),
    },
    {
      name: 'プラン',
      disabled: true,
      handler: action('handlePlan'),
    },
    {
      name: '契約容量',
      disabled: true,
      handler: action('handleCap'),
    },
  ],
};
export const Fill = Template1.bind({});
Fill.args = {
  selectors: [
    {
      name: '電力会社',
      selected: '東京電力エナジーパートナー',
      handler: action('handleCorp'),
    },
    {
      name: 'プラン',
      selected: '従量電灯C',
      description: '選択肢の説明文を表示するコンポーネント',
      handler: action('handlePlan'),
    },
    {
      name: '契約容量',
      selected: '49kVA',
      handler: action('handleCap'),
    },
  ],
};
export const NonCap = Template1.bind({});
NonCap.args = {
  selectors: [
    {
      name: '電力会社',
      selected: '東京電力エナジーパートナー',
      handler: action('handleCorp'),
    },
    {
      name: 'プラン',
      selected: '従量電灯C',
      description: '選択肢の説明文を表示するコンポーネント',
      handler: action('handlePlan'),
    },
    {
      name: '契約容量',
      selected: '49kVA',
    },
  ],
};
