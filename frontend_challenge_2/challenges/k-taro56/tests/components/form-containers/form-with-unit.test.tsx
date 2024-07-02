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

  it('validates the range of the input value', () => {
    const onValueChange = jest.fn();
    const setErrorMessage = jest.fn();

    const { getByPlaceholderText } = render(
      <FormWithUnitFormContainer
        required={true}
        label='Test Label'
        isVisible={true}
        placeholder='Test Placeholder'
        value={undefined}
        unit='kg'
        min={10}
        max={20}
        onValueChange={onValueChange}
        errorMessage=''
        setErrorMessage={setErrorMessage}
      />,
    );

    const input = getByPlaceholderText('Test Placeholder');

    fireEvent.change(input, { target: { value: '5' } });
    expect(setErrorMessage).toHaveBeenCalledWith('10 kg以上を入力してください');
    expect(onValueChange).toHaveBeenCalledWith(undefined);

    fireEvent.change(input, { target: { value: '25' } });
    expect(setErrorMessage).toHaveBeenCalledWith('20 kg以下を入力してください');
    expect(onValueChange).toHaveBeenCalledWith(undefined);

    fireEvent.change(input, { target: { value: '15' } });
    expect(setErrorMessage).toHaveBeenCalledWith('');
    expect(onValueChange).toHaveBeenCalledWith(15);
  });

  it('validates when the input value is undefined', () => {
    const onValueChange = jest.fn();
    const setErrorMessage = jest.fn();

    const { getByPlaceholderText } = render(
      <FormWithUnitFormContainer
        required={true}
        label='Test Label'
        isVisible={true}
        placeholder='Test Placeholder'
        value={0}
        unit='kg'
        onValueChange={onValueChange}
        errorMessage=''
        setErrorMessage={setErrorMessage}
      />,
    );

    const input = getByPlaceholderText('Test Placeholder');

    fireEvent.change(input, { target: { value: '' } });
    expect(setErrorMessage).toHaveBeenCalledWith('入力してください');
    expect(onValueChange).toHaveBeenCalledWith(undefined);
  });
});
