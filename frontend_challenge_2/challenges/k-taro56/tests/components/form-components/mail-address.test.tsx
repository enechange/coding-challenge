import React from 'react';
import { render, fireEvent } from '@testing-library/react';

import MailAddressForm from '../../../src/components/form-components/mail-address';

describe('MailAddressForm', () => {
  it('should render correctly', () => {
    const { getByPlaceholderText } = render(
      <MailAddressForm
        required={true}
        label='Email'
        inputValue=''
        errorMessage=''
        onInputValueChange={() => {}}
      />,
    );

    expect(getByPlaceholderText('mail@example.com')).toBeInTheDocument();
  });

  it('should call onInputValueChange when input changes', () => {
    const mockFn = jest.fn();
    const { getByPlaceholderText } = render(
      <MailAddressForm
        required={true}
        label='Email'
        inputValue=''
        errorMessage=''
        onInputValueChange={mockFn}
      />,
    );

    fireEvent.change(getByPlaceholderText('mail@example.com'), {
      target: { value: 'test@example.com' },
    });

    expect(mockFn).toHaveBeenCalledWith('test@example.com');
  });
});
