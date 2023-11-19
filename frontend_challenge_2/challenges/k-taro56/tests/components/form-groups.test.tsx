import React from 'react';
import { render, screen } from '@testing-library/react';

import FormGroup from '../../src/components/form-groups';

describe('FormGroup', () => {
  it('renders the label and children correctly', () => {
    const testLabel = 'Test Label';
    const testChild = <div>Test Child</div>;

    render(<FormGroup label={testLabel}>{testChild}</FormGroup>);

    expect(screen.getByText(testLabel)).toBeInTheDocument();
    expect(screen.getByText('Test Child')).toBeInTheDocument();
  });
});
