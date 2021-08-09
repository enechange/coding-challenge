import React from "react";
import styled from 'styled-components'
import Input from "../components/base/Input";
import SubCaption from '../components/SubCaption';
import ErrorMessage from "../components/ErrorMessage";
import { Colors } from '../assets/Colors'

const Wrapper = styled.div`
  width: 90%;
  margin: 48px auto 12px;
`;

const InputWrapper = styled.div`
  margin: 12px 0;
  padding: 8px;
  background: ${Colors.gray};
  border-radius: 4px;
  display: flex;
  > p {
    font-size: 25px;
    line-height: 60px;
    margin: 0 20px;
  }
`;

const StyledInput = styled(Input)`
  width: 50%;
  height: 60px;
  border: none;
  font-size: 30px;
  letter-spacing: 1px;
  text-align: center;
`;

const InputPostalCode = props => {
  const { inputPostalAreaCode, inputLocalAreaCode, isOutOfArea } = props;
  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="電気を使用する場所の郵便番号" />
      <InputWrapper>
        <StyledInput maxlength={3} handleInput={inputPostalAreaCode} />
        <p>-</p>
        <StyledInput maxlength={4} handleInput={inputLocalAreaCode} />
      </InputWrapper>
      {isOutOfArea && <ErrorMessage innerText="サービスエリア対象外です。" />}
    </Wrapper>
  );
}
export default InputPostalCode;
