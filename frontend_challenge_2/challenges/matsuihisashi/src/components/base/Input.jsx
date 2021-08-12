import React from "react";
import styled from 'styled-components';

const InputBox = styled.input`
  height: 80px;
  border: none;
  font-size: 30px;
  letter-spacing: 1px;
`;

const Input = props => {
  const { maxlength, handleInput, className } = props;
  return (
    <>
      <InputBox maxLength={maxlength} className={className} type="text" onChange={handleInput} />
    </>
  );
};

export default Input;
