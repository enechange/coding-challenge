import { render, screen } from '@testing-library/react';
import SubmitButton from '../../src/components/submit-button';

describe('SubmitButton', () => {
  it('renders the button with the correct content', () => {
    render(<SubmitButton content='Test Button' />);

    const buttonElement = screen.getByRole('button', { name: /Test Button/i });
    expect(buttonElement).toBeInTheDocument();
  });

  it('renders the button with the correct type', () => {
    render(<SubmitButton content='Test Button' />);

    const buttonElement = screen.getByRole('button', { name: /Test Button/i });
    expect(buttonElement).toHaveAttribute('type', 'submit');
  });
});
