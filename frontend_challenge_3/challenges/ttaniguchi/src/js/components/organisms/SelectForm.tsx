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

export type Selector = {
  name: string;
  selected?: string;
  description?: string;
  disabled?: boolean;
  handler?: () => void;
};

export type Props = {
  selectors: Selector[];
};
const SelectForm: FC<Props> = ({ selectors }) => {
  return (
    <StyledRoot>
      <Title>電気のご使用状況について教えてください</Title>
      {selectors.map(
        ({ name, selected, description, disabled, handler }) =>
          handler && (
            <ContainerLayout key={name}>
              <FieldLabel>{name}</FieldLabel>
              <InputLayout>
                <SelectButton
                  label={selected || unselected}
                  description={description}
                  disabled={disabled}
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
