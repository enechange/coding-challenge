import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import { FocusStyle } from '@/styles/focus-styles';

export const Input = styled.input`
  border: 0.25rem solid ${Light.border};
  border-radius: 0.25rem;
  padding: 0.75rem;
  @media (prefers-color-scheme: dark) {
    border: 0.25rem solid ${Dark.border};
    background-color: #222;
    color: #ddd;
  }
  ${FocusStyle}
`;
