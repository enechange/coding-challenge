import React from 'react';
import { Colors } from '../Colors'

const NextArrow = props => {
  const { width, height, color } = props;
  return (
    <svg
      width={width ?? "50"}
      height={height ?? "50"}
      viewBox={`0, 0, ${width ?? "50"}, ${height ?? "50"}`}
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M1.47003 0L0.530029 0.94L3.58336 4L0.530029 7.06L1.47003 8L5.47003 4L1.47003 0Z"
      fill={color ?? Colors.white}
    />
    </svg>
  )
};

export default NextArrow;
