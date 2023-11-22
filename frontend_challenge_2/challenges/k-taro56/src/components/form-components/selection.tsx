import React from 'react';
import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import FormBase from './form-base';

const SelectWrapper = styled.div`
  position: relative;
  &::before {
    content: 'expand_more';
    font-family: var(--font-material-symbols);
    font-size: 1.75rem;
    color: ${Light.accent};
    position: absolute;
    left: 0.5rem;
    top: 50%;
    transform: translateY(-50%);
    pointer-events: none;
    @media (prefers-color-scheme: dark) {
      color: ${Dark.accent};
    }
  }
`;

const SelectionInput = styled.select`
  border-top: 0.25rem solid #ddd;
  border-left: 0.25rem solid #ddd;
  border-right: 0.25rem solid #ddd;
  border-bottom: 0;
  border-top-left-radius: 0.25rem;
  border-top-right-radius: 0.25rem;
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 2.25rem;
  padding-right: 0.75rem;
  width: 100%;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  &:focus {
    outline: none;
    box-shadow: inset 0 0 0.25rem ${Light.accent};
  }
  @media (prefers-color-scheme: dark) {
    border-top: 0.25rem solid #555;
    border-left: 0.25rem solid #555;
    border-right: 0.25rem solid #555;
    border-bottom: 0;
    background-color: #222;
    color: #ddd;
    &:focus {
      box-shadow: inset 0 0 0.5rem ${Dark.accent};
    }
  }
`;

const DottedLine = styled.div`
  border-top: #ddd dotted 0.1rem;
  @media (prefers-color-scheme: dark) {
    border-top: #555 dotted 0.1rem;
  }
`;

const Description = styled.div`
  border-bottom-left-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
  font-size: 0.75rem;
  font-weight: normal;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  padding-left: 0.75rem;
  padding-right: 0.75rem;
  background-color: #ddd;
  @media (prefers-color-scheme: dark) {
    background-color: #555;
    color: #ddd;
  }
`;

const BottomBorder = styled.div`
  border-bottom: 0.25rem solid #ddd;
  border-bottom-left-radius: 0.25rem;
  border-bottom-right-radius: 0.25rem;
  @media (prefers-color-scheme: dark) {
    border-bottom: 0.25rem solid #555;
  }
`;

type SelectionFromProps = {
  label: string;
  required: boolean;
  isVisible?: boolean;
  selections: string[];
  selected: string;
  descriptions?: string[];
  errorMessage: string;
  onSelectionChange: (value: string) => void;
};

const SelectionForm = ({
  label,
  required,
  isVisible,
  selections,
  selected,
  descriptions,
  errorMessage,
  onSelectionChange,
}: SelectionFromProps) => {
  const handleSelectionChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    onSelectionChange(e.target.value);
  };
  return (
    <FormBase
      label={label}
      required={required}
      isVisible={isVisible}
      errorMessage={errorMessage}
    >
      <div>
        <SelectWrapper>
          <SelectionInput
            required={required}
            value={selected}
            onChange={handleSelectionChange}
          >
            <option value='' disabled>
              選択してください
            </option>
            {selections.map((selection) => (
              <option key={selection} value={selection}>
                {selection}
              </option>
            ))}
          </SelectionInput>
        </SelectWrapper>
        {descriptions ? (
          <div>
            <DottedLine />
            <Description>
              {descriptions[selections.indexOf(selected)]}
            </Description>
          </div>
        ) : (
          <BottomBorder />
        )}
      </div>
    </FormBase>
  );
};

export default SelectionForm;
