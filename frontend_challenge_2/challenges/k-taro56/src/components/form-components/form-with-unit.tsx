import React from 'react';
import styled from '@emotion/styled';

import { Input } from '@/styles/styled-html-tags';
import FormBase from './form-base';

const Container = styled.div`
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
`;

const FormWithUnitInput = styled(Input)`
  &::-webkit-inner-spin-button,
  &::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
`;

const Unit = styled.span`
  font-weight: normal;
  margin-left: 0.5rem;
`;

type FormWithUnitProps = {
  required: boolean;
  label: string;
  isVisible?: boolean;
  placeholder: string;
  inputValue: string;
  unit: string;
  min?: number;
  max?: number;
  errorMessage: string;
  onInputValueChange: (value: string) => void;
};

const FormWithUnit = ({
  required,
  label,
  isVisible,
  placeholder,
  inputValue,
  unit,
  min,
  max,
  errorMessage,
  onInputValueChange,
}: FormWithUnitProps) => {
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    onInputValueChange(e.target.value);
  };

  return (
    <FormBase
      required={required}
      label={label}
      isVisible={isVisible}
      errorMessage={errorMessage}
    >
      <Container>
        <FormWithUnitInput
          type='number'
          required={required}
          placeholder={placeholder}
          value={inputValue}
          min={min}
          max={max}
          onChange={handleInputChange}
        />
        <Unit>{unit}</Unit>
      </Container>
    </FormBase>
  );
};

export default FormWithUnit;
