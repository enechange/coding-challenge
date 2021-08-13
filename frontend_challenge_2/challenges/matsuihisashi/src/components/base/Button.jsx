import React from "react";
import styled from 'styled-components'
import { Colors } from '../../assets/Colors'

const Wrapper = styled.button`
  width: 100%;
  padding: 30px 0;
  font-size: 30px;
  border: none;
  border-radius: 4px;
  color: ${Colors.white};
  background: ${(props) => props.color ?? Colors.blue};
  pointer-events: ${(props) => props.isActive ? "auto" : "none"};
  opacity: ${(props) => props.isActive ? "1" : "0.5"};
`;

const Button = props => {
  const { innertext, color, onClick, isActive } = props;
  return (
    <Wrapper color={color} onClick={onClick} isActive={isActive}>
      {innertext}
    </Wrapper>
  );
};

export default Button;
