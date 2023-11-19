import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import FormatPostCodeContainer, {
  formatPostCode,
  validatePostCode,
} from '../../../src/components/form-containers/post-code';

describe('PostCode functions', () => {
  describe('formatPostCode', () => {
    it('should return the same value if length is less than or equal to 3', () => {
      expect(formatPostCode('123')).toBe('123');
    });

    it('should format the post code correctly if length is more than 3', () => {
      expect(formatPostCode('1234567')).toBe('123 4567');
    });
  });

  describe('validatePostCode', () => {
    it('should return true for valid post code', () => {
      expect(validatePostCode('1234567')).toBe(true);
    });

    it('should return false for invalid post code', () => {
      expect(validatePostCode('123456')).toBe(false);
      expect(validatePostCode('12345678')).toBe(false);
      expect(validatePostCode('123456a')).toBe(false);
    });
  });
});

describe('FormatPostCodeContainer', () => {
  const setPostCode = jest.fn();
  const commonProps = {
    required: false,
    label: 'Post Code',
    postCode: '',
    setPostCode,
  };

  it('should render without crashing', () => {
    render(<FormatPostCodeContainer {...commonProps} />);
  });

  it('should handle input change', () => {
    const { getByLabelText } = render(
      <FormatPostCodeContainer {...commonProps} />,
    );
    const input = getByLabelText('Post Code');

    fireEvent.change(input, { target: { value: '1234567' } });

    expect(setPostCode).toHaveBeenCalledWith('1234567');
  });

  it('should display an error message when the post code is less than 7 digits', () => {
    const { getByLabelText, getByText } = render(
      <FormatPostCodeContainer {...commonProps} />,
    );
    const input = getByLabelText('Post Code');

    fireEvent.change(input, { target: { value: '123456' } });

    expect(getByText('郵便番号を正しく入力してください')).toBeInTheDocument();
  });

  it('should display an error message when the post code is more than 7 digits', () => {
    const { getByLabelText } = render(
      <FormatPostCodeContainer {...commonProps} />,
    );
    const input = getByLabelText('Post Code');

    fireEvent.change(input, { target: { value: '12345678' } });

    expect(setPostCode).toHaveBeenCalledWith('1234567');
  });
});
