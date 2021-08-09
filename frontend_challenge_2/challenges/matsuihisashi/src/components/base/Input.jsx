import React from "react";

const Input = props => {
  const { maxlength, handleInput, className } = props;
  return (
    <>
      <input maxLength={maxlength} className={className} type="text" onChange={handleInput} />
    </>
  );
}
export default Input;