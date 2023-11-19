'use client';

import styled from '@emotion/styled';
import { FormGroupElementProps } from '@/types/form-grroups-element-props';

const LightThemeBackgroundColor = 'white';
const DarkThemeBackgroundColor = '#1a202c';

const FormGroupContainer = styled.div`
  padding-top: 1rem;
  padding-bottom: 1rem;
  margin-bottom: 1rem;
  background-color: ${LightThemeBackgroundColor};
  @media (prefers-color-scheme: dark) {
    background-color: ${DarkThemeBackgroundColor};
  }
`;

const FormGroupRibbon = styled.div`
  background-color: #ed9b38;
  @media (prefers-color-scheme: dark) {
    background-color: #935d1d;
  }
`;

const FormGroupLabel = styled.div`
  font-size: 1.5rem;
  font-weight: bold;
  margin-left: 0.25rem;
  padding: 0.5rem;
  background-color: ${LightThemeBackgroundColor};
  @media (prefers-color-scheme: dark) {
    background-color: ${DarkThemeBackgroundColor};
  }
`;

const FormGroupChildContainer = styled.div`
  padding: 0.75rem;
`;

type FormGroupProps = {
  label: string;
  children:
    | React.ReactElement<FormGroupElementProps>
    | React.ReactElement<FormGroupElementProps>[];
};

const FormGroup = ({ label, children }: FormGroupProps) => {
  return (
    <FormGroupContainer>
      <FormGroupRibbon>
        <FormGroupLabel>{label}</FormGroupLabel>
      </FormGroupRibbon>
      <FormGroupChildContainer>{children}</FormGroupChildContainer>
    </FormGroupContainer>
  );
};

export default FormGroup;
