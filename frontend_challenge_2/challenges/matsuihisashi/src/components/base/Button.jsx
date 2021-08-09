import React from "react";
import styled from 'styled-components'
import { Colors } from '../../assets/Colors'
// import Icon from '../../assets/svgIcons';

const Wrapper = styled.button`
  width: 100%;
  padding: 24px 0;
  font-size: 30px;
  border: none;
  border-radius: 4px;
  color: ${Colors.white};
  background: ${(props) => props.color ?? Colors.blue};
`;

const Button = props => {
  const { innertext, color, onClick } = props;
  return (
    <Wrapper color={color} onClick={onClick}>
      {innertext}
    </Wrapper>
  );
}
export default Button;
