import React, { FC, useEffect, useRef } from 'react';
import styled from 'styled-components';

const StyledRoot = styled.div`
  align-items: center;
  background: var(--body-group);
  border-radius: 4px;
  display: flex;
  height: 48px;
  justify-content: space-between;
  padding: 4px;
`;
const StyledInput = styled.input`
  border: 0;
  font-size: 16px;
  height: 100%;
  outline: none;
  text-align: center;
  width: 100%;

  &:hover,
  &:focus {
    box-shadow: inset 0 0 4px 0.5px var(--line-primary);
  }
`;
const StyledBar = styled.div`
  align-items: center;
  display: flex;
  justify-content: center;
  padding: 12px;
`;

export type Props = {
  code: [string, string];
  onChange: (code: [string, string]) => void;
};
const PostalInput: FC<Props> = ({ code: [code1, code2], onChange }) => {
  const code1Ref = useRef<HTMLInputElement | null>(null);
  const code2Ref = useRef<HTMLInputElement | null>(null);

  useEffect(() => {
    if (code1.length >= 3) {
      code2Ref?.current?.focus();
    }
    if (code2.length >= 4) {
      code2Ref?.current?.blur();
    }
  }, [code1, code2]);

  return (
    <StyledRoot>
      <StyledInput
        type="tel"
        name="code1"
        ref={code1Ref}
        value={code1}
        maxLength={3}
        onChange={(e) => onChange([e.target.value, code2])}
      />
      <StyledBar>-</StyledBar>
      <StyledInput
        type="tel"
        name="code2"
        ref={code2Ref}
        value={code2}
        maxLength={4}
        onChange={(e) => onChange([code1, e.target.value])}
      />
    </StyledRoot>
  );
};

export default PostalInput;
