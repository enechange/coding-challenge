import React from "react";
import styled from 'styled-components';
import { Colors } from '../../assets/Colors';

const Wrapper = styled.p`
  padding: 2px 8px;
  background: ${Colors.red};
  font-size: 15px;
  margin: 0;
  color: ${Colors.white};
`;

const Label = props => {
  const { innertext } = props;
  return (
    <Wrapper>{innertext}</Wrapper>
  );
};

export default Label;
