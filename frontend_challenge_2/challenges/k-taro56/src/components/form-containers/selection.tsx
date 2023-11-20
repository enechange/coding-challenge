'use client';

import { FormGroupElementProps } from '@/types/form-groups-element-props';
import Selection from '../form-components/selection';

export interface SelectionFormContainerProps extends FormGroupElementProps {
  required: boolean;
  label: string;
  isVisible?: boolean;
  selections: string[];
  selected: string;
  onSelectionChange: (selected: string) => void;
  errorMessage: string;
  setErrorMessage: (errorMessage: string) => void;
}

const SelectionFormContainer = ({
  required,
  label,
  isVisible,
  selections,
  selected,
  onSelectionChange,
  errorMessage,
  setErrorMessage,
}: SelectionFormContainerProps) => {
  const handleSelectionChange = (value: string) => {
    if (value === '') {
      setErrorMessage('選択してください');
    } else {
      setErrorMessage('');
      onSelectionChange(value);
    }
  };

  return (
    <Selection
      required={required}
      label={label}
      isVisible={isVisible}
      selections={selections}
      selected={selected}
      errorMessage={errorMessage}
      onSelectionChange={handleSelectionChange}
    />
  );
};

export default SelectionFormContainer;
