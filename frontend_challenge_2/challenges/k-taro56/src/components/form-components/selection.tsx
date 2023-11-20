import React from 'react';
import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import FormBase from './form-base';

const SelectionInput = styled.select`
  border: 0.25rem solid #ddd;
  border-radius: 0.25rem;
  padding: 0.75rem;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  &:focus {
    outline: none;
    box-shadow: inset 0 0 0.25rem ${Light.accent};
  }
  @media (prefers-color-scheme: dark) {
    border: 0.25rem solid #555;
    background-color: #222;
    color: #ddd;
    &:focus {
      box-shadow: inset 0 0 0.5rem ${Dark.accent};
    }
  }
`;

type SelectionFromProps = {
  label: string;
  required: boolean;
  isVisible?: boolean;
  selections: string[];
  selected: string;
  errorMessage: string;
  onSelectionChange: (value: string) => void;
};

const SelectionForm = ({
  label,
  required,
  isVisible,
  selections,
  selected,
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
    </FormBase>
  );
};

export default SelectionForm;
