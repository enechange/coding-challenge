import { render, fireEvent } from '@testing-library/react';

import MailAddressFormContainer from '../../../src/components/form-containers/mail-address';

describe('MailAddressFormContainer', () => {
  it('should validate email address correctly', () => {
    const mockSetErrorMessage = jest.fn();
    const mockOnMailAddressChange = jest.fn();

    const { getByLabelText } = render(
      <MailAddressFormContainer
        required={false}
        label='Email'
        isVisible={true}
        mailAddress=''
        onMailAddressChange={mockOnMailAddressChange}
        mailAddressErrorMessage=''
        setMailAddressErrorMessage={mockSetErrorMessage}
      />,
    );

    const input = getByLabelText('Email');

    // Test with invalid email
    fireEvent.change(input, { target: { value: 'invalid email' } });
    expect(mockSetErrorMessage).toHaveBeenCalledWith(
      'メールアドレスを正しく入力してください',
    );
    expect(mockOnMailAddressChange).toHaveBeenCalledWith('');

    // Test with valid email
    fireEvent.change(input, { target: { value: 'test@example.com' } });
    expect(mockSetErrorMessage).toHaveBeenCalledWith('');
    expect(mockOnMailAddressChange).toHaveBeenCalledWith('test@example.com');
  });
});
