'use client';

import { useState } from 'react';

import { FormGroupElementProps } from '@/types/form-groups-element-props';
import FormWithUnit from '../form-components/form-with-unit';

export interface FormWithUnitFormContainerProps extends FormGroupElementProps {
  required: boolean;
  label: string;
  isVisible?: boolean;
  placeholder: string;
  value: number | undefined;
  unit: string;
  min?: number;
  max?: number;
  onValueChange: (value: number | undefined) => void;
  errorMessage: string;
  setErrorMessage: (errorMessage: string) => void;
}

const FormWithUnitFormContainer = ({
  required,
  label,
  isVisible,
  placeholder,
  value,
  unit,
  min,
  max,
  onValueChange,
  errorMessage,
  setErrorMessage,
}: FormWithUnitFormContainerProps) => {
  const [inputValue, setInputValue] = useState(value?.toString() || '');

  const onInputValueChange = (inputValue: string) => {
    setInputValue(inputValue);
    if (inputValue === '') {
      setErrorMessage('入力してください');
      onValueChange(undefined);
    } else {
      setErrorMessage('');
      onValueChange(Number(inputValue));
    }
  };

  return (
    <FormWithUnit
      required={required}
      label={label}
      isVisible={isVisible}
      placeholder={placeholder}
      inputValue={inputValue}
      unit={unit}
      min={min}
      max={max}
      errorMessage={errorMessage}
      onInputValueChange={onInputValueChange}
    />
  );
};

export default FormWithUnitFormContainer;
