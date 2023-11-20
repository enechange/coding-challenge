import React from 'react';
import styled from '@emotion/styled';

import FormBase from './form-base';

const PostCodeInput = styled.input`
  border: 0.25rem solid #ddd;
  border-radius: 0.25rem;
  padding: 0.75rem;
  &:focus {
    outline: none;
    box-shadow: inset 0 0 0.25rem #ed9b38;
  }
  @media (prefers-color-scheme: dark) {
    border: 0.25rem solid #555;
    background-color: #222;
    color: #ddd;
    &:focus {
      box-shadow: inset 0 0 0.5rem #935d1d;
    }
  }
`;

type PostCodeFormProps = {
  required: boolean;
  label: string;
  inputValue: string;
  errorMessage: string;
  handleInputChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
};

const PostCodeForm = ({
  required,
  label,
  inputValue,
  errorMessage,
  handleInputChange,
}: PostCodeFormProps) => {
  return (
    <FormBase required={required} label={label} errorMessage={errorMessage}>
      <PostCodeInput
        type='text'
        pattern='\d*'
        required={required}
        placeholder='130 0012'
        value={inputValue}
        onChange={handleInputChange}
      />
    </FormBase>
  );
};

export default PostCodeForm;
