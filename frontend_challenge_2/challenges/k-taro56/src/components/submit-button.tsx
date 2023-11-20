import styled from '@emotion/styled';

const Button = styled.button`
  position: relative;
  font-size: 1rem;
  font-style: bold;
  margin: 0.75rem;
  padding: 1rem;
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
  width: calc(100% - 1.5rem);
  background-color: #007bff;
  color: var(--color);
  &:hover {
    background-color: #0056b3;
  }
  &:active {
    background-color: #004085;
  }
  @media (prefers-color-scheme: dark) {
    background-color: #0f4a8a;
    &:hover {
      background-color: #0056b3;
    }
    &:active {
      background-color: #082748;
    }
  }
  &::after {
    position: absolute;
    right: 1.25rem;
    font-size: 1.25rem;
    font-family: var(--font-material-symbols);
    content: 'expand_circle_right';
    font-variation-settings: 'FILL' 1;
  }
`;

type ButtonProps = {
  content: string;
};

const SubmitButton = ({ content }: ButtonProps) => {
  return <Button type='submit'>{content}</Button>;
};

export default SubmitButton;
