import React, { FC } from 'react';
import styled from 'styled-components';
import Title from '@/js/components/atoms/Title';
import CostInput from '@/js/components/molecules/CostInput';
import FieldLabel from '@/js/components/molecules/FieldLabel';
import WarningLabel from '@/js/components/molecules/WarningLabel';

const StyledRoot = styled.div`
  background: var(--white);
  padding: 24px 0 8px;
`;
const ContainerLayout = styled.div`
  padding: 32px 24px;
`;
const InputLayout = styled.div`
  align-items: center;
  display: flex;
  padding: 8px 0;
`;
const StyledYen = styled.div`
  padding: 16px;
`;

export type Props = {
  cost?: number;
  error?: string;
  onBlur?: () => void;
  onChange: (cost: number) => void;
};
const CostForm: FC<Props> = ({ cost, error, onBlur, onChange }) => (
  <StyledRoot>
    <Title>現在の電気の使用状況について教えてください</Title>
    <ContainerLayout>
      <FieldLabel>先月の電気代は？</FieldLabel>
      <InputLayout>
        <CostInput
          cost={cost ? cost.toString() : ''}
          onBlur={onBlur}
          onChange={(str) => onChange(parseInt(str, 10))}
        />
        <StyledYen>円</StyledYen>
      </InputLayout>
      {error && <WarningLabel>{error}</WarningLabel>}
    </ContainerLayout>
  </StyledRoot>
);
export default CostForm;
