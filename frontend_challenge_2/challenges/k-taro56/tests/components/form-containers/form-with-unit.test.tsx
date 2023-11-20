import { render, fireEvent } from '@testing-library/react';
import FormWithUnitFormContainer from '../../../src/components/form-containers/form-with-unit';

describe('FormWithUnitFormContainer', () => {
  it('renders without crashing', () => {
    const mockFn = jest.fn();
    render(
      <FormWithUnitFormContainer
        required={true}
        label='Test Label'
        isVisible={true}
        placeholder='Test Placeholder'
        value={10}
        unit='kg'
        min={5}
        max={15}
        onValueChange={mockFn}
        errorMessage=''
        setErrorMessage={mockFn}
      />,
    );
  });

  it('calls onValueChange with the correct value when input changes', () => {
    const mockFn = jest.fn();
    const { getByPlaceholderText } = render(
      <FormWithUnitFormContainer
        required={true}
        label='Test Label'
        isVisible={true}
        placeholder='Test Placeholder'
        value={10}
        unit='kg'
        min={5}
        max={15}
        onValueChange={mockFn}
        errorMessage=''
        setErrorMessage={mockFn}
      />,
    );

    const input = getByPlaceholderText('Test Placeholder');
    fireEvent.change(input, { target: { value: '12' } });

    expect(mockFn).toHaveBeenCalledWith(12);
  });
});
