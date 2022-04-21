import React, { FC } from 'react';
import styled from 'styled-components';

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
  email?: string;
  disabled?: boolean;
  onBlur?: () => void;
  onChange: (email: string) => void;
};
const EmailInput: FC<Props> = ({ email, disabled, onBlur, onChange }) => (
  <StyledRoot>
    <StyledInput
      type="email"
      name="email"
      value={email || ''}
      disabled={!!disabled}
      onBlur={onBlur}
      onChange={(e) => onChange(e.target.value)}
    />
  </StyledRoot>
);

export default EmailInput;
