import React from 'react';
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';

import Header from '../../src/components/header';

describe('Header component', () => {
  it('renders title and subtitle correctly', () => {
    const title = 'Test Title';
    const subTitle = 'Test Subtitle';

    render(<Header title={title} subTitle={subTitle} />);

    expect(screen.getByText(title)).toBeInTheDocument();
    expect(screen.getByText(subTitle)).toBeInTheDocument();
  });

  it('renders multiline text correctly', () => {
    const title = 'Line1\\nLine2';
    const subTitle = 'LineA\\nLineB';

    render(<Header title={title} subTitle={subTitle} />);

    expect(screen.getByText('Line1')).toBeInTheDocument();
    expect(screen.getByText('Line2')).toBeInTheDocument();
    expect(screen.getByText('LineA')).toBeInTheDocument();
    expect(screen.getByText('LineB')).toBeInTheDocument();
  });
});
