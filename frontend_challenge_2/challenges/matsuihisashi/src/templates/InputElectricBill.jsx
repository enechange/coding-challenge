import React from "react";
import styled from 'styled-components';
import Input from "../components/base/Input";
import SubCaption from '../components/SubCaption';
import ErrorMessage from "../components/ErrorMessage";
import { Colors } from '../assets/Colors';

const Wrapper = styled.div`
  width: 92%;
  margin: 48px auto 12px;
`;

const Container = styled.div`
  display: flex;
  align-items: center;
  > p {
    font-size: 25px;
    margin-left: 16px;
  }
`;

const InputWrapper = styled.div`
  width: 100%;
  pointer-events: ${(props) => props.isActive ? "auto" : "none"};
  opacity: ${(props) => props.isActive ? "1" : "0.5"};
  margin: 12px 0;
  padding: 8px;
  background: ${Colors.gray};
  border-radius: 4px;
`;

const StyledInput = styled(Input)`
  width: calc(100% - 34px);
  padding-left: 30px;
`;

const InputElectricBill = props => {
  const { inputElectricBill, isInvalidElectricBill, isActive } = props;
  return (
    <Wrapper>
      <SubCaption labelText="必 須" captionText="先月の電気代は？" />
      <Container>
        <InputWrapper isActive={isActive}>
          <StyledInput handleInput={inputElectricBill} type="number" />
        </InputWrapper>
        <p>円</p>
      </Container>
      {isInvalidElectricBill && <ErrorMessage innerText="電気代を正しく入力してください。最低料金は1,000円です。" />}
    </Wrapper>
  );
};

export default InputElectricBill;
