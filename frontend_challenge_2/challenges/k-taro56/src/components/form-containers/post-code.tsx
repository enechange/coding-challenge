'use client';

import React, { useState } from 'react';

import { FormGroupElementProps } from '@/types/form-grroups-element-props';
import PostCodeForm from '../form-components/post-code';

export interface PostCodeFormContainerProps extends FormGroupElementProps {
  required: boolean;
  label: string;
  postCode: string;
  setPostCode: (postCode: string) => void;
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
  postCode,
  setPostCode,
}: PostCodeFormContainerProps) => {
  const [inputValue, setInputValue] = useState(
    formatPostCode(postCode?.toString() || ''),
  );
  const [errorMessage, setErrorMessage] = useState('');

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    let value = e.target.value.replace(/[^0-9]/g, '');
    if (7 < value.length) {
      value = value.slice(0, 7);
    }
    setInputValue(formatPostCode(value));
    if (!validatePostCode(value)) {
      setErrorMessage('郵便番号を正しく入力してください');
      setPostCode('');
    } else {
      switch (value[0]) {
        case '1':
        case '5':
          setErrorMessage('');
          setPostCode(value);
          break;
        default:
          setErrorMessage('サービスエリア対象外です');
          setPostCode('');
          break;
      }
    }
  };

  return (
    <PostCodeForm
      required={required}
      label={label}
      inputValue={inputValue}
      errorMessage={errorMessage}
      handleInputChange={handleInputChange}
    />
  );
};

export default FormatPostCodeContainer;
