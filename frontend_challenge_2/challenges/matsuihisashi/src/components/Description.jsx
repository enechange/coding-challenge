import React from "react";
import styled from 'styled-components'
import { Colors } from '../assets/Colors'
import { TextS } from './base/Text';

const Wrapper = styled.div`
  padding: 12px 20px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  background: ${Colors.gray};
`;

const StyledTextS = styled(TextS)`
  color: ${Colors.black};
  margin-left: 12px;
`;

const Description = props => {
  const { className, innerText } = props;
  return (
    <Wrapper className={className}>
      <StyledTextS>{innerText}</StyledTextS>
    </Wrapper>
  );
}
export default Description;
