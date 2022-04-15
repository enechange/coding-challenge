import React, { FC } from 'react';
import Required from '@/js/components/atoms/Required';
import styled from 'styled-components';

const StyledRoot = styled.div`
  align-items: center;
  display: flex;
  font-size: 16px;
  font-weight: bold;
  line-height: 16px;
`;
const RequiredLayout = styled.div`
  padding-right: 8px;
`;

export type Props = {
  children: string;
};
const FieldLabel: FC<Props> = ({ children }) => (
  <StyledRoot>
    <RequiredLayout>
      <Required />
    </RequiredLayout>
    {children}
  </StyledRoot>
);

export default FieldLabel;
