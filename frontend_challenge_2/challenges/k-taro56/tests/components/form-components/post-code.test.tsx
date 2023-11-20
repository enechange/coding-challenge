import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import PostCodeForm from '../../../src/components/form-components/post-code';

describe('PostCodeForm', () => {
  it('renders correctly', () => {
    const { getByLabelText } = render(
      <PostCodeForm
        required={false}
        label='Post Code'
        inputValue=''
        errorMessage=''
        onInputValueChange={() => {}}
      />,
    );

    expect(getByLabelText('Post Code')).toBeInTheDocument();
  });

  it('handles input change', () => {
    const handleInputChange = jest.fn();
    const { getByLabelText } = render(
      <PostCodeForm
        required={false}
        label='Post Code'
        inputValue=''
        errorMessage=''
        onInputValueChange={handleInputChange}
      />,
    );

    fireEvent.change(getByLabelText('Post Code'), {
      target: { value: '123456' },
    });
    expect(handleInputChange).toHaveBeenCalled();
  });

  it('displays error message when provided', () => {
    const { getByText } = render(
      <PostCodeForm
        required={true}
        label='Post Code'
        inputValue=''
        errorMessage='Invalid post code'
        onInputValueChange={() => {}}
      />,
    );

    expect(getByText('Invalid post code')).toBeInTheDocument();
  });
});
