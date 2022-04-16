import React, { FC } from 'react';
import styled from 'styled-components';

const StyledRoot = styled.div`
  font-size: 20px;
  font-weight: bold;
  padding: 8px 16px;
  border-left: 6px solid var(--line-primary);
`;

export type Props = {
  children: string;
};
const Label: FC<Props> = ({ children }) => <StyledRoot>{children}</StyledRoot>;

export default Label;
