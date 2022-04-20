import React, { FC } from 'react';
import styled from 'styled-components';
import Title from '@/js/components/atoms/Title';
import EmailInput from '@/js/components/molecules/EmailInput';
import FieldLabel from '@/js/components/molecules/FieldLabel';
import WarningLabel from '@/js/components/molecules/WarningLabel';

const StyledRoot = styled.div`
  background: var(--white);
  padding: 24px 0 8px;
`;
const ContainerLayout = styled.div`
  padding: 32px 24px;
`;
const InputLayout = styled.div`
  padding: 8px 0;
`;

export type Props = {
  email?: string;
  error?: string;
  onBlur?: () => void;
  onChange: (email: string) => void;
};
const EmailForm: FC<Props> = ({ email, error, onBlur, onChange }) => (
  <StyledRoot>
    <Title>ご連絡先を教えてください</Title>
    <ContainerLayout>
      <FieldLabel>メールアドレス</FieldLabel>
      <InputLayout>
        <EmailInput email={email} onBlur={onBlur} onChange={onChange} />
      </InputLayout>
      {error && <WarningLabel>{error}</WarningLabel>}
    </ContainerLayout>
  </StyledRoot>
);
export default EmailForm;
