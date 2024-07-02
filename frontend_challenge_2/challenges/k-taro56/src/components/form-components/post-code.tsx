import React from 'react';

import { Input } from '@/styles/styled-html-tags';
import FormBase from './form-base';

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
      <Input
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
