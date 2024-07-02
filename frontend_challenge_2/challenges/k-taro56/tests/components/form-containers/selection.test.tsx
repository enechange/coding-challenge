import { render, fireEvent } from '@testing-library/react';
import SelectionFormContainer from '../../../src/components/form-containers/selection';

describe('SelectionFormContainer', () => {
  it('should render without crashing', () => {
    const mockProps = {
      required: true,
      label: 'Test Label',
      isVisible: true,
      selections: ['Option 1', 'Option 2'],
      selected: 'Option 1',
      descriptions: ['Description 1', 'Description 2'],
      onSelectionChange: jest.fn(),
      errorMessage: '',
      setErrorMessage: jest.fn(),
    };

    const { getByText } = render(<SelectionFormContainer {...mockProps} />);
    expect(getByText('Test Label')).toBeInTheDocument();
  });

  it('should call setErrorMessage when selection is empty', () => {
    const mockProps = {
      required: true,
      label: 'Test Label',
      isVisible: true,
      selections: ['Option 1', 'Option 2'],
      selected: '',
      descriptions: ['Description 1', 'Description 2'],
      onSelectionChange: jest.fn(),
      errorMessage: '',
      setErrorMessage: jest.fn(),
    };

    const { getByRole } = render(<SelectionFormContainer {...mockProps} />);
    fireEvent.change(getByRole('combobox'), { target: { value: '' } });
    expect(mockProps.setErrorMessage).toHaveBeenCalledWith('選択してください');
  });

  it('should call onSelectionChange when selection is not empty', () => {
    const mockProps = {
      required: true,
      label: 'Test Label',
      isVisible: true,
      selections: ['Option 1', 'Option 2'],
      selected: 'Option 1',
      descriptions: ['Description 1', 'Description 2'],
      onSelectionChange: jest.fn(),
      errorMessage: '',
      setErrorMessage: jest.fn(),
    };

    const { getByRole } = render(<SelectionFormContainer {...mockProps} />);
    fireEvent.change(getByRole('combobox'), { target: { value: 'Option 2' } });
    expect(mockProps.onSelectionChange).toHaveBeenCalledWith('Option 2');
  });
});
