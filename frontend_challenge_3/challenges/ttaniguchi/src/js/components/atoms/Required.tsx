import React, { FC } from 'react';
import styled from 'styled-components';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-required);
  color: var(--text-primary);
  display: flex;
  font-size: 10px;
  font-weight: bold;
  justify-content: center;
  letter-spacing: 0.5em;
  line-height: 10px;
  padding: 4px;
  width: 44px;
`;

const Required: FC = () => <StyledRoot>必須</StyledRoot>;

export default Required;
