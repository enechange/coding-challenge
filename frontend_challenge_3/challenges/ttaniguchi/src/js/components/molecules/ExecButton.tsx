import React, { FC } from 'react';
import styled from 'styled-components';
import More from '@/js/components/atoms/icons/More';

const StyledButton = styled.button<{ disabled: boolean }>`
  align-items: center;
  ${({ disabled }) =>
    disabled
      ? `
  background: var(--body-disabled);
  `
      : `
  background: var(--body-button);
  `}
  border: 0;
  border-radius: 4px;
  display: flex;
  height: 64px;
  justify-content: end;
  padding: 0 16px;
  outline: none;
  position: relative;
  width: 100%;
`;
const StyledLabel = styled.div`
  color: var(--white);
  font-size: 20px;
  line-height: 20px;
  height: 20px;
  padding-right: 0;
  position: absolute;
  left: 0;
  right: 0;
`;
const StyledIcon = styled.div`
  align-items: center;
  background: var(--white);
  border-radius: 20px;
  display: flex;
  height: 20px;
  justify-content: end;
  transform: rotate(-90deg);
  width: 20px;
`;

export type Props = {
  disabled: boolean;
  onClick: () => void;
};
const ExecButton: FC<Props> = ({ disabled, onClick }) => (
  <StyledButton onClick={onClick} disabled={disabled}>
    <StyledLabel>結果を見る</StyledLabel>
    <StyledIcon>
      <More height={24} width={24} color={disabled ? '#aaaaaa' : '#3d5b97'} />
    </StyledIcon>
  </StyledButton>
);

export default ExecButton;
