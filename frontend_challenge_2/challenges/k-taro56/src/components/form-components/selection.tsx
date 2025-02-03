import React from 'react';
import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import { FocusStyle } from '@/styles/focus-styles';
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

const SelectionInputBase = styled.select`
  padding-top: 0.75rem;
  padding-bottom: 0.75rem;
  padding-left: 2.25rem;
  padding-right: 0.75rem;
  width: 100%;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  @media (prefers-color-scheme: dark) {
    background-color: #222;
    color: #ddd;
  }
  ${FocusStyle}
`;

const SelectionInputWithDescription = styled(SelectionInputBase)`
  border-top: 0.25rem solid ${Light.border};
  border-left: 0.25rem solid ${Light.border};
  border-right: 0.25rem solid ${Light.border};
  border-bottom: 0;
  border-top-left-radius: 0.25rem;
  border-top-right-radius: 0.25rem;
  @media (prefers-color-scheme: dark) {
    border-top: 0.25rem solid ${Dark.border};
    border-left: 0.25rem solid ${Dark.border};
    border-right: 0.25rem solid ${Dark.border};
    border-bottom: 0;
  }
`;

const SelectionInputWithoutDescription = styled(SelectionInputBase)`
  border: 0.25rem solid ${Light.border};
  border-radius: 0.25rem;
  @media (prefers-color-scheme: dark) {
    border: 0.25rem solid ${Dark.border};
  }
`;

const DottedLine = styled.div`
  border-top: ${Light.border} dotted 0.1rem;
  @media (prefers-color-scheme: dark) {
    border-top: ${Dark.border} dotted 0.1rem;
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
  background-color: ${Light.border};
  @media (prefers-color-scheme: dark) {
    background-color: ${Dark.border};
    color: #ddd;
  }
`;

type SelectionFromProps = {
  label: string;
  required: boolean;
  isVisible?: boolean;
  selections: readonly string[];
  selected: string;
  descriptions?: readonly string[];
  errorMessage: string;
  onSelectionChange: (value: string) => void;
};

const renderOptions = (selections: readonly string[]) => {
  return (
    <>
      <option value='' disabled>
        選択してください
      </option>
      {selections.map((selection) => (
        <option key={selection} value={selection}>
          {selection}
        </option>
      ))}
    </>
  );
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
      <SelectWrapper>
        {descriptions ? (
          <div>
            <SelectionInputWithDescription
              required={required}
              value={selected}
              onChange={handleSelectionChange}
            >
              {renderOptions(selections)}
            </SelectionInputWithDescription>
            <DottedLine />
            <Description>
              {descriptions[selections.indexOf(selected)]}
            </Description>
          </div>
        ) : (
          <SelectionInputWithoutDescription
            required={required}
            value={selected}
            onChange={handleSelectionChange}
          >
            {renderOptions(selections)}
          </SelectionInputWithoutDescription>
        )}
      </SelectWrapper>
    </FormBase>
  );
};

export default SelectionForm;
