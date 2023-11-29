'use client';

import { useState } from 'react';

import type { FormGroupElementProps } from '@/types/form-groups-element-props';
import MailAddress from '../form-components/mail-address';

export interface MailAddressFormContainerProps extends FormGroupElementProps {
  required: boolean;
  label: string;
  isVisible?: boolean;
  mailAddress: string;
  onMailAddressChange: (mailAddress: string) => void;
  mailAddressErrorMessage: string;
  setMailAddressErrorMessage: (mailAddressErrorMessage: string) => void;
}

export const validateMailAddress = (value: string) => {
  const regex = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/;
  return regex.test(value);
};

const MailAddressFormContainer = ({
  required,
  label,
  isVisible,
  mailAddress,
  onMailAddressChange,
  mailAddressErrorMessage,
  setMailAddressErrorMessage,
}: MailAddressFormContainerProps) => {
  const [inputValue, setInputValue] = useState(mailAddress);

  const onInputValueChange = (inputValue: string) => {
    setInputValue(inputValue);
    if (!validateMailAddress(inputValue)) {
      setMailAddressErrorMessage('メールアドレスを正しく入力してください');
      onMailAddressChange('');
    } else {
      setMailAddressErrorMessage('');
      onMailAddressChange(inputValue);
    }
  };

  return (
    <MailAddress
      required={required}
      label={label}
      isVisible={isVisible}
      inputValue={inputValue}
      onInputValueChange={onInputValueChange}
      errorMessage={mailAddressErrorMessage}
    />
  );
};

export default MailAddressFormContainer;
