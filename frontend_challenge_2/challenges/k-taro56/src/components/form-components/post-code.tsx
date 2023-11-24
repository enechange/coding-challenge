import React from 'react';
import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import FormBase from './form-base';

const PostCodeInput = styled.input`
  border: 0.25rem solid ${Light.border};
  border-radius: 0.25rem;
  padding: 0.75rem;
  &:focus {
    outline: none;
    box-shadow: inset 0 0 0.25rem ${Light.accent};
  }
  @media (prefers-color-scheme: dark) {
    border: 0.25rem solid ${Dark.border};
    background-color: #222;
    color: #ddd;
    &:focus {
      box-shadow: inset 0 0 0.5rem ${Dark.accent};
    }
  }
`;

type PostCodeFormProps = {
  required: boolean;
  label: string;
  isVisible?: boolean;
  inputValue: string;
  errorMessage: string;
  onInputValueChange: (value: string) => void;
};

const PostCodeForm = ({
  required,
  label,
  isVisible,
  inputValue,
  errorMessage,
  onInputValueChange,
}: PostCodeFormProps) => {
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
      <PostCodeInput
        type='text'
        pattern='\d{3} \d{4}'
        required={required}
        placeholder='130 0012'
        value={inputValue}
        onChange={handleInputChange}
      />
    </FormBase>
  );
};

export default PostCodeForm;
