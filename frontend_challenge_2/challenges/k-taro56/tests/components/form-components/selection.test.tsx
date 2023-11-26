import React from 'react';
import { render, fireEvent } from '@testing-library/react';
import SelectionForm from '../../../src/components/form-components/selection';

describe('SelectionForm', () => {
  const mockOnSelectionChange = jest.fn();

  const props = {
    label: 'Test Label',
    required: true,
    isVisible: true,
    selections: ['Option 1', 'Option 2', 'Option 3'],
    selected: 'Option 1',
    descriptions: ['Description 1', 'Description 2', 'Description 3'],
    errorMessage: 'Test Error Message',
    onSelectionChange: mockOnSelectionChange,
  };

  it('renders without crashing', () => {
    render(<SelectionForm {...props} />);
  });

  it('calls onSelectionChange when an option is selected', () => {
    const { getByRole } = render(<SelectionForm {...props} />);
    const select = getByRole('combobox');
    fireEvent.change(select, { target: { value: 'Option 2' } });
    expect(mockOnSelectionChange).toHaveBeenCalledWith('Option 2');
  });

  it('renders the correct number of options', () => {
    const { getAllByRole } = render(<SelectionForm {...props} />);
    const options = getAllByRole('option');
    expect(options.length).toBe(props.selections.length + 1); // +1 for the disabled option
  });

  it('renders the correct label', () => {
    const { getByText } = render(<SelectionForm {...props} />);
    const label = getByText(props.label);
    expect(label).toBeInTheDocument();
  });

  it('renders the correct description for the selected option', () => {
    const { getByText } = render(<SelectionForm {...props} />);
    const description = getByText(
      props.descriptions[props.selections.indexOf(props.selected)],
    );
    expect(description).toBeInTheDocument();
  });
});
