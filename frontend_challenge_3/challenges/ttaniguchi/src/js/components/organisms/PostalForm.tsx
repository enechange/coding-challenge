import React, { FC } from 'react';
import styled from 'styled-components';
import Title from '@/js/components/atoms/Title';
import PostalInput from '@/js/components/molecules/PostalInput';
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
  code: [string, string];
  error?: string;
  onChange: (code: [string, string]) => void;
};
const PostalForm: FC<Props> = ({ code, error, onChange }) => (
  <StyledRoot>
    <Title>郵便番号をご入力ください</Title>
    <ContainerLayout>
      <FieldLabel>電気を使用する場所の郵便番号</FieldLabel>
      <InputLayout>
        <PostalInput code={code} onChange={onChange} />
      </InputLayout>
      {error && <WarningLabel>{error}</WarningLabel>}
    </ContainerLayout>
  </StyledRoot>
);
export default PostalForm;
