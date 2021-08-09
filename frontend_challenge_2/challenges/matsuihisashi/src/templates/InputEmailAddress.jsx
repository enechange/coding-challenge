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
  pointer-events: ${(props) => props.isActive ? "auto" : "none"};
  opacity: ${(props) => props.isActive ? "1" : "0.5"};
  > div {
    width: 100%;
    margin: 12px 0;
    padding: 8px;
    background: ${Colors.gray};
    border-radius: 4px;
  }
  > p {
    font-size: 25px;
    line-height: 60px;
    margin: 0 16px;
  }
`;

const StyledInput = styled(Input)`
  width: calc(100% - 31px);
  height: 60px;
  border: none;
  font-size: 30px;
  letter-spacing: 1px;
  padding-left: 30px;
`;

const InputEmailAddress = props => {
  const { inputElectricBill, isInvalidEmailAddress, isActive } = props;
  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="" />
      <InputWrapper isActive={isActive}>
        <div>
          <StyledInput handleInput={inputElectricBill} />
        </div>
        {/* <div>
          <StyledInput handleInput={inputElectricBill} />
        </div> */}
      </InputWrapper>
      {isInvalidEmailAddress && <ErrorMessage innerText="メールアドレスを正しく入力してください。" />}
    </Wrapper>
  );
}
export default InputEmailAddress;
