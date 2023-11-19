import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';

import FormBase from '../../../src/components/form-components/form-base';

describe('FormBase', () => {
  test('renders FormBase component', () => {
    render(
      <FormBase
        required={true}
        label='Test Label'
        errorMessage='Test Error'
        children={<div>Test Child</div>}
      />,
    );

    expect(screen.getByText('必須')).toBeInTheDocument();
    expect(screen.getByText('Test Label')).toBeInTheDocument();
    expect(screen.getByText('Test Error')).toBeInTheDocument();
    expect(screen.getByText('Test Child')).toBeInTheDocument();
  });

  test('does not render error message when errorMessage is empty', () => {
    render(
      <FormBase
        required={true}
        label='Test Label'
        errorMessage=''
        children={<div>Test Child</div>}
      />,
    );

    expect(screen.queryByText('Test Error')).toBeNull();
  });
});
