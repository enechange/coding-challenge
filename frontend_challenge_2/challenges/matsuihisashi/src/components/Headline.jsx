import React from "react";
import styled from 'styled-components';
import { TextL, TextM } from './base/Text';

const Wrapper = styled.div`
  text-align: center;
  padding: 40px 0 60px;
`;

const StyledTextM = styled(TextM)`
  margin-top: 20px;
`;

const Headline = () => {
  return (
    <Wrapper>
      <TextL>電気代から<br/>かんたんシミュレーション</TextL>
      <StyledTextM>検針票を用意しなくてもOK<br/>いくらおトクになるか今すぐわかります！</StyledTextM>
    </Wrapper>
  );
};

export default Headline;
