import React, { FC } from 'react';
import styled from 'styled-components';
import Title from '@/js/components/atoms/Title';
import SelectButton from '@/js/components/molecules/SelectButton';
import FieldLabel from '@/js/components/molecules/FieldLabel';

const StyledRoot = styled.div`
  background: var(--white);
  padding: 24px 0 32px;
`;
const ContainerLayout = styled.div`
  padding: 32px 32px 0;
`;
const InputLayout = styled.div`
  padding: 8px 0;
`;

const unselected = '- 未選択 -' as const;

export type Props = {
  selectedCorp?: string;
  selectedPlan?: [string, string];
  selectedCap?: number;
  onClickCorp?: () => void;
  onClickPlan?: () => void;
  onClickCap?: () => void;
};
const SelectForm: FC<Props> = ({
  selectedCorp,
  selectedPlan: [selectedPlan, selectedPlanDescription] = [],
  selectedCap,
  onClickCorp,
  onClickPlan,
  onClickCap,
}) => {
  const DATA = [
    {
      name: '電力会社',
      selected: selectedCorp || unselected,
      handler: onClickCorp,
    },
    {
      name: 'プラン',
      selected: selectedPlan || unselected,
      description: selectedPlanDescription,
      handler: onClickPlan,
    },
    {
      name: '契約容量',
      selected: selectedCap ? `${selectedCap}kVA` : unselected,
      handler: onClickCap,
    },
  ];

  return (
    <StyledRoot>
      <Title>電気のご使用状況について教えてください</Title>
      {DATA.map(
        ({ name, selected, description, handler }) =>
          handler && (
            <ContainerLayout>
              <FieldLabel>{name}</FieldLabel>
              <InputLayout>
                <SelectButton
                  label={selected || unselected}
                  description={description}
                  onClick={handler}
                />
              </InputLayout>
            </ContainerLayout>
          ),
      )}
    </StyledRoot>
  );
};
export default SelectForm;
