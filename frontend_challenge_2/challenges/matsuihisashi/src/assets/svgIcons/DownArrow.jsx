import React from 'react';
import { Colors } from '../Colors';

const DownArrow = props => {
  const { width, height, color } = props;
  return (
    <svg width={width ?? "20"} height={height ?? "20"} fill={color ?? Colors.white} xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
      <path d="M16.59 8.3L12 12.87 7.41 8.3 6 9.7l6 6 6-6-1.41-1.4z"/>
    </svg>
  )
};

export default DownArrow;
