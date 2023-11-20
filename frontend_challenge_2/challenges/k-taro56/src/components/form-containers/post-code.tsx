'use client';

import { useState } from 'react';

import { FormGroupElementProps } from '@/types/form-groups-element-props';
import PostCodeForm from '../form-components/post-code';

export interface PostCodeFormContainerProps extends FormGroupElementProps {
  required: boolean;
  label: string;
  isVisible?: boolean;
  postCode: string;
  onPostCodeChange: (postCode: string) => void;
  postCodeErrorMessage: string;
  setPostCodeErrorMessage: (postCodeErrorMessage: string) => void;
}

export const formatPostCode = (value: string) => {
  if (value.length <= 3) {
    return value;
  }
  return value.slice(0, 3) + ' ' + value.slice(3);
};

export const validatePostCode = (value: string) => {
  const regex = /^\d{7}$/;
  return regex.test(value);
};

const FormatPostCodeContainer = ({
  required,
  label,
  isVisible,
  postCode,
  onPostCodeChange,
  postCodeErrorMessage,
  setPostCodeErrorMessage,
}: PostCodeFormContainerProps) => {
  const [inputValue, setInputValue] = useState(
    formatPostCode(postCode?.toString() || ''),
  );

  const onInputValueChange = (inputValue: string) => {
    let value = inputValue.replace(/[^0-9]/g, '');
    if (7 < value.length) {
      value = value.slice(0, 7);
    }
    setInputValue(formatPostCode(value));
    if (!validatePostCode(value)) {
      setPostCodeErrorMessage('郵便番号を正しく入力してください');
      onPostCodeChange('');
    } else {
      setPostCodeErrorMessage('');
      onPostCodeChange(value);
    }
  };

  return (
    <PostCodeForm
      required={required}
      label={label}
      isVisible={isVisible}
      inputValue={inputValue}
      errorMessage={postCodeErrorMessage}
      onInputValueChange={onInputValueChange}
    />
  );
};

export default FormatPostCodeContainer;
