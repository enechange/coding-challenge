import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import FormWithUnit from '../../../src/components/form-components/form-with-unit';

describe('FormWithUnit', () => {
  it('renders correctly', () => {
    const { getByPlaceholderText, getByText } = render(
      <FormWithUnit
        required={true}
        label='Test Label'
        placeholder='Test Placeholder'
        inputValue='Test Value'
        unit='Test Unit'
        errorMessage='Test Error'
        onInputValueChange={() => {}}
      />,
    );

    expect(getByPlaceholderText('Test Placeholder')).toBeInTheDocument();
    expect(getByText('Test Unit')).toBeInTheDocument();
  });

  it('calls onInputValueChange on input change', () => {
    const onInputValueChange = jest.fn();
    const { getByPlaceholderText } = render(
      <FormWithUnit
        required={true}
        label='Test Label'
        placeholder='Test Placeholder'
        inputValue='Test Value'
        unit='Test Unit'
        errorMessage='Test Error'
        onInputValueChange={onInputValueChange}
      />,
    );

    fireEvent.change(getByPlaceholderText('Test Placeholder'), {
      target: { value: '12345' },
    });
    expect(onInputValueChange).toHaveBeenCalledWith('12345');
  });
});
