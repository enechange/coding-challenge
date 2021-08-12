import React from "react";
import styled from 'styled-components';
import { TextL } from './base/Text';
import { Colors } from '../assets/Colors';

const Wrapper = styled.div`
  border-left: 6px solid ${Colors.orange};
`;

const StyledTextL = styled(TextL)`
  margin-left: 4%;
  padding: 16px 0;
  margin-top: 20px;
`;

const Caption = props => {
  const { innerText } = props;
  return (
    <Wrapper>
      <StyledTextL>{innerText}</StyledTextL>
    </Wrapper>
  );
};

export default Caption;
