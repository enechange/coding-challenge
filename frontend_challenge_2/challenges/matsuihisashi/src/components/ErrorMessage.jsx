import React from "react";
import styled from 'styled-components';
import { Colors } from '../assets/Colors';
import { TextS } from './base/Text';
import Icon from '../assets/svgIcons';

const Wrapper = styled.div`
  padding: 20px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  background: ${Colors.red};
`;

const StyledTextS = styled(TextS)`
  color: ${Colors.white};
  margin-left: 12px;
`;

const ErrorMessage = props => {
  const { className, innerText } = props;
  return (
    <Wrapper className={className}>
      <Icon.Warning />
      <StyledTextS>{innerText}</StyledTextS>
    </Wrapper>
  );
};

export default ErrorMessage;
