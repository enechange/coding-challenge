'use client';

import styled from '@emotion/styled';

import { Light, Dark } from '@/colors/theme';
import { FormGroupElementProps } from '@/types/form-groups-element-props';

const LightThemeBackgroundColor = 'white';
const DarkThemeBackgroundColor = '#1a202c';

const FormGroupContainer = styled.div`
  padding-top: 1rem;
  padding-bottom: 0;
  margin-bottom: 1rem;
  background-color: ${LightThemeBackgroundColor};
  @media (prefers-color-scheme: dark) {
    background-color: ${DarkThemeBackgroundColor};
  }
`;

const FormGroupRibbon = styled.div`
  background-color: ${Light.accent};
  @media (prefers-color-scheme: dark) {
    background-color: ${Dark.accent};
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
  isVisible?: boolean;
  children?:
    | React.ReactElement<FormGroupElementProps>
    | React.ReactElement<FormGroupElementProps>[];
};

const FormGroup = ({ label, isVisible, children }: FormGroupProps) => {
  return (
    <FormGroupContainer hidden={!(isVisible ?? true)}>
      <FormGroupRibbon>
        <FormGroupLabel>{label}</FormGroupLabel>
      </FormGroupRibbon>
      <FormGroupChildContainer>{children}</FormGroupChildContainer>
    </FormGroupContainer>
  );
};

export default FormGroup;
