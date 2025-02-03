import { Light, Dark } from '@/colors/theme';

export const FocusStyle = `
  &:focus {
    outline: none;
    box-shadow: inset 0 0 0.25rem ${Light.accent};
  }
  @media (prefers-color-scheme: dark) {
    &:focus {
      box-shadow: inset 0 0 0.5rem ${Dark.accent};
    }
  }
`;
