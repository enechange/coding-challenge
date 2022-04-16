import React from 'react';
import { Meta, Story } from '@storybook/react';
import { action } from '@storybook/addon-actions';

import SelectForm, { Props } from './SelectForm';

export default {
  title: 'challenge/organisms/SelectForm',
  component: SelectForm,
} as Meta;

const Template1: Story<Props> = (args) => (
  <SelectForm
    {...args}
    onClickCorp={action('onClickCorp')}
    onClickPlan={action('onClickPlan')}
    onClickCap={action('onClickCap')}
  />
);

export const Default = Template1.bind({});
export const Fill = Template1.bind({});
Fill.args = {
  selectedCorp: '東京電力エナジーパートナー',
  selectedPlan: ['従量灯C', '選択肢の説明文を表示するコンポーネント'],
  selectedCap: 49,
  onClickCap: action('onClickCap'),
};

const Template2: Story<Props> = () => (
  <SelectForm
    selectedCorp="東京電力エナジーパートナー"
    selectedPlan={['従量灯C', '選択肢の説明文を表示するコンポーネント']}
    selectedCap={49}
    onClickCorp={action('onClickCorp')}
    onClickPlan={action('onClickPlan')}
    onClickCap={undefined}
  />
);
export const NonCap = Template2.bind({});
