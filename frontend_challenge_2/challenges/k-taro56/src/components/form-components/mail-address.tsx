import React from 'react';
import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import FormBase from './form-base';

const MailAddressInput = styled.input`
  border: 0.25rem solid #ddd;
  border-radius: 0.25rem;
  padding: 0.75rem;
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

type MailAddressProps = {
  required: boolean;
  label: string;
  isVisible?: boolean;
  inputValue: string;
  errorMessage: string;
  onInputValueChange: (value: string) => void;
};

const MailAddressForm = ({
  required,
  label,
  isVisible,
  inputValue,
  errorMessage,
  onInputValueChange,
}: MailAddressProps) => {
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
      <MailAddressInput
        type='email'
        required={required}
        placeholder='mail@example.com'
        value={inputValue}
        pattern='[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
        onChange={handleInputChange}
      />
    </FormBase>
  );
};

export default MailAddressForm;
