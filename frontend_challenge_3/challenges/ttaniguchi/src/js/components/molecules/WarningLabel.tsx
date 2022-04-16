import React, { FC } from 'react';
import styled from 'styled-components';
import Warning from '@/js/components/atoms/icons/Warning';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-required);
  border-radius: 4px;
  color: var(--text-primary);
  display: flex;
  font-size: 12px;
  line-height: 12px;
  padding: 10px 12px;
  width: 100%;
`;
const IconLayout = styled.div`
  padding-right: 8px;
`;

export type Props = {
  children: string;
};
const WarningLabel: FC = ({ children }) => (
  <StyledRoot>
    <IconLayout>
      <Warning color="#fff" height={20} width={20} />
    </IconLayout>
    {children}
  </StyledRoot>
);

export default WarningLabel;
