import React, { FC, Fragment } from 'react';
import styled from 'styled-components';
import Title from '@/js/components/atoms/Title';
import SelectButton from '@/js/components/molecules/SelectButton';
import FieldLabel from '@/js/components/molecules/FieldLabel';
import WarningLabel from '@/js/components/molecules/WarningLabel';

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
  error?: string;
};
const SelectForm: FC<Props> = ({ selectors, error }) => {
  return (
    <StyledRoot>
      <Title>電気のご使用状況について教えてください</Title>
      <ContainerLayout>
        {selectors.map(
          ({ name, selected, description, disabled, handler }) =>
            handler && (
              <Fragment key={name}>
                <FieldLabel>{name}</FieldLabel>
                <InputLayout>
                  <SelectButton
                    label={selected || unselected}
                    description={description}
                    disabled={disabled}
                    onClick={handler}
                  />
                </InputLayout>
              </Fragment>
            ),
        )}
        {error && <WarningLabel>{error}</WarningLabel>}
      </ContainerLayout>
    </StyledRoot>
  );
};
export default SelectForm;
