import styled from '@emotion/styled';

type FormBaseProps = {
  required: boolean;
  label: string;
  isVisible?: boolean;
  errorMessage: string;
  children: React.ReactElement;
};

const Container = styled.div`
  margin-bottom: 2rem;
`;

const RequiredLabel = styled.span`
  font-size: 0.75rem;
  margin-right: 0.5rem;
  padding-top: 0.25rem;
  padding-bottom: 0.25rem;
  padding-left: 0.5rem;
  letter-spacing: 0.5rem;
  color: white;
  background-color: #e66059;
  @media (prefers-color-scheme: dark) {
    color: #ddd;
    background-color: #982d27;
  }
`;

const Label = styled.label`
  font-weight: bold;
  display: flex;
  flex-direction: column;

  & > span {
    margin-bottom: 0.5rem;
  }
`;

const Error = styled.div`
  font-size: 0.75rem;
  margin-top: 0.5rem;
  margin-bottom: 0.5rem;
  padding: 0.75rem;
  color: white;
  background-color: #e66059;
  border-radius: 0.25rem;
  display: flex;
  align-items: center;
  @media (prefers-color-scheme: dark) {
    color: #ddd;
    background-color: #982d27;
  }
`;

const MaterialSymbols = styled.span`
  font-size: 1rem;
  margin-right: 0.5rem;
  font-family: var(--font-material-symbols);
  font-variation-settings: 'FILL' 1;
`;

const FormBase = ({
  required,
  label,
  isVisible,
  errorMessage,
  children,
}: FormBaseProps) => {
  return (
    <Container hidden={!(isVisible ?? true)}>
      <Label>
        <span>
          {required && (
            <span>
              <RequiredLabel>必須</RequiredLabel>
            </span>
          )}
          {label}
        </span>
        {children}
      </Label>
      {errorMessage.length !== 0 && (
        <Error>
          <MaterialSymbols>warning</MaterialSymbols>
          {errorMessage}
        </Error>
      )}
    </Container>
  );
};

export default FormBase;
