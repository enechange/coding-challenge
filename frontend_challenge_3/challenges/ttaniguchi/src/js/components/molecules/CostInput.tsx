import React, { FC, useCallback } from 'react';
import styled from 'styled-components';
import { fixNum, zen2han } from '@/js/libs/valid';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-group);
  border-radius: 4px;
  display: flex;
  height: 48px;
  justify-content: space-between;
  padding: 4px;
  width: 100%;
`;
const StyledInput = styled.input<{ disabled: boolean }>`
  border: 0;
  font-size: 16px;
  height: 100%;
  outline: none;
  padding-left: 1em;
  width: 100%;

  ${({ disabled }) =>
    disabled
      ? `
    background: var(--body-default);
    color: var(--text-disabled);
    `
      : `
    &:hover,
      &:focus {
        box-shadow: inset 0 0 4px 0.5px var(--line-primary);
      }
    `}
`;

export type Props = {
  cost: string;
  disabled?: boolean;
  onBlur?: () => void;
  onChange: (cost: string) => void;
};
const CostInput: FC<Props> = ({ cost, disabled, onBlur, onChange }) => {
  const check = useCallback(
    (cost: string, befCost: string) =>
      cost ? fixNum(zen2han(cost), befCost) : '',
    [],
  );

  return (
    <StyledRoot>
      <StyledInput
        type="tel"
        name="cost"
        value={cost}
        disabled={!!disabled}
        onBlur={onBlur}
        onChange={(e) => onChange(check(e.target.value, cost))}
      />
    </StyledRoot>
  );
};

export default CostInput;
