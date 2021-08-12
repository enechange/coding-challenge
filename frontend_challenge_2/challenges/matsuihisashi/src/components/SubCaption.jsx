import React from "react";
import styled from 'styled-components'
import { TextM } from './base/Text';
import Label from './base/Label';

const Wrapper = styled.div`
  display: flex;
  align-items: center;
`;

const StyledTextM = styled(TextM)`
  font-weight: bold;
  margin-left: 8px;
`;

const SubCaption = props => {
  const { labelText, captionText } = props;
  return (
    <Wrapper>
      <Label innertext={labelText} />
      <StyledTextM>{captionText}</StyledTextM>
    </Wrapper>
  );
};

export default SubCaption;
